import 'package:http/http.dart' as http;
import 'dart:convert';

class ContentGenerationService {
  final String modelUrl;
  final String apiKey;

  ContentGenerationService({required this.modelUrl, required this.apiKey});

  Future<String> generateCourseContent(
      String chapterName, String courseName) async {
    try {
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
        final responseData = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        if (responseData['choices'] != null &&
            responseData['choices'].isNotEmpty) {
          return responseData['choices'][0]['message']['content'];
        } else {
          throw Exception('لا يوجد محتوى متولد في الاستجابة');
        }
      } else {
        throw Exception('فشل في توليد المحتوى: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء توليد المحتوى: $e');
    }
  }
}