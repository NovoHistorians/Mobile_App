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
          // Authorization header removed since Flask API does not require it
        },
        // body: jsonEncode({
        //   'question': prompt, // Adapt to Flask API's expected input
        // }),
        body: jsonEncode({
          'question': prompt, // Adapt to Flask API's expected input
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        // final content = data['response'];

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
