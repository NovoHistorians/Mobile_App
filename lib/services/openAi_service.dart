import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  final String apiKey;
  final String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  //final String baseUrl = 'http://192.168.213.40:5000/query';

  OpenAIService(this.apiKey);

  Future<String> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        // body: jsonEncode({
        //   'question': prompt, // Adapt to Flask API's expected input
        // }),
        body: jsonEncode({
          'model':
              'llama-3.3-70b-versatile', // Changed model for better Arabic support
          'messages': [
            {
              'role': 'system',
              'content': '''أنت مساعد تعليمي متخصص في التاريخ الجزائري. 
              يجب أن تجيب دائماً باللغة العربية الفصحى.
              يجب أن تكون إجاباتك واضحة ومفهومة للطلاب.
              يجب أن تستخدم التشكيل عند الضرورة.'''
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        // final content = data['response'];

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
