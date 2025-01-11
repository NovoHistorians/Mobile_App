import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  final String apiKey;
  final String baseUrl = 'http://172.28.0.12:5000/query';

  OpenAIService(this.apiKey);

  // Map for level transformations
  final Map<String, String> levelMapping = {
    'الثالثة إبتدائي': "3AP",
    'الرابعة إبتدائي': "4AP",
    'الخامسة إبتدائي': "5AP",
    'الأولى متوسط': "1AM",
    'الثانية متوسط': "2AM",
    'الثالثة متوسط': "3AM",
    'الرابعة متوسط': "4AM",
    'الثالثة ثانوي': "3HS",
    'الثانية ثانوي': "2HS",
    'الأولى ثانوي': "1HS",
  };

// Function to map Arabic levels to API format
  String mapLevel(String levelFromFirestore) {
    return levelMapping[levelFromFirestore] ?? 'UNI';
  }

  Future<String> getResponse(String prompt, String levelFromFirestore) async {
    try {
      // Map the level to the required format
      final level = mapLevel(levelFromFirestore);

      // Ensure the mapped `level` is valid
      if (level.isEmpty) {
        throw Exception('Invalid level provided or no mapping found.');
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          // Authorization header removed since Flask API does not require it
        },
        body: jsonEncode({
          'question': prompt, // Question input for the Flask API
          'level': level, // Mapped level for dynamic index initialization
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the final response from the Flask API
        final content = data['response'];
        print(content);

        // Verify Arabic content
        if (!RegExp(r'[\u0600-\u06FF]').hasMatch(content)) {
          throw Exception('الرد لا يحتوي على نص عربي صحيح');
        }

        return content;
      } else {
        print('Error response: ${utf8.decode(response.bodyBytes)}');
        throw Exception('فشل في الحصول على استجابة: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخدمة: $e');
    }
  }
}
