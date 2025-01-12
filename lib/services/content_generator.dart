import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContentGenerationService {
  final String modelUrl;
  final String apiKey;

  final int maxRetries;
  final Duration initialRetryDelay;
  final Map<String, DateTime> lastRequestTimes = {};

  ContentGenerationService({
    required this.modelUrl,
    required this.apiKey,
    this.maxRetries = 3,
    this.initialRetryDelay = const Duration(seconds: 1),
  });

  Future<void> _waitForCooldown() async {
    const cooldownPeriod = Duration(seconds: 1);
    final now = DateTime.now();
    final lastRequest = lastRequestTimes[modelUrl];

    if (lastRequest != null) {
      final timeSinceLastRequest = now.difference(lastRequest);
      if (timeSinceLastRequest < cooldownPeriod) {
        await Future.delayed(cooldownPeriod - timeSinceLastRequest);
      }
    }

    lastRequestTimes[modelUrl] = now;
  }

  Future<String> generateCourseContent(
      String chapterName, String courseName) async {
    int retryCount = 0;

    while (true) {
      try {
        await _waitForCooldown();

        final response = await http.post(
          Uri.parse(modelUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode({
            'model': 'llama-3.1-8b-instant',
            'messages': [
              {
                'role': 'user',
                'content':
                    'قم بتوليد محتوى مختصر ونقاط رئيسية للدورة "$courseName" تحت الفصل "$chapterName" بتنسيق Markdown. استخدم "#" للعناوين الرئيسية و "##" للعناوين الفرعية و "*" للنقاط و "---" لفصل الأقسام. تأكد من أن المحتوى باللغة العربية.',
              }
            ],
            'max_tokens': 1000,
            'temperature': 0.7,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          if (responseData['choices'] != null &&
              responseData['choices'].isNotEmpty) {
            return responseData['choices'][0]['message']['content'];
          }
          throw Exception('لا يوجد محتوى متولد في الاستجابة');
        } else if (response.statusCode == 429) {
          if (retryCount >= maxRetries) {
            throw Exception('تم تجاوز الحد الأقصى لمحاولات إعادة المحاولة');
          }

          // Calculate exponential backoff delay
          final delay = initialRetryDelay * pow(2, retryCount);
          print('Rate limited. Retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
          retryCount++;
          continue;
        } else {
          throw Exception('فشل في توليد المحتوى: ${response.statusCode}');
        }
      } catch (e) {
        if (e.toString().contains('429') && retryCount < maxRetries) {
          retryCount++;
          final delay = initialRetryDelay * pow(2, retryCount);
          print('Error occurred. Retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
          continue;
        }
        throw Exception('حدث خطأ أثناء توليد المحتوى: $e');
      }
    }
  }
}
