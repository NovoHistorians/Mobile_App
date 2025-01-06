import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/quiz_model.dart';

class QuizGeneratorService {
  final String apiKey;
  final String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  QuizGeneratorService(this.apiKey);

  String _getDifficultyPrompt(String level, String year) {
    if (level == 'الإبتدائي') {
      return 'أسئلة بسيطة ومباشرة مناسبة للمرحلة الابتدائية';
    } else if (level == 'المتوسط') {
      return 'أسئلة متوسطة الصعوبة تتطلب بعض التفكير';
    } else if (level == 'الثانوي') {
      return 'أسئلة تحليلية وتفكير نقدي مناسبة للمرحلة الثانوية';
    } else {
      return 'أسئلة متقدمة تتطلب تحليلاً عميقاً وفهماً شاملاً';
    }
  }

  Future<Quiz> generateQuiz(
      String courseContent, String level, String year) async {
    try {
      developer.log('Starting quiz generation for level: $level, year: $year');
      developer.log('Course content length: ${courseContent.length}');

      final difficultyPrompt = _getDifficultyPrompt(level, year);

      developer.log('Making API request to Groq');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile', // Changed to a more stable model
          'messages': [
            {
              'role': 'system',
              'content': '''أنت معلم متخصص في إنشاء الاختبارات التعليمية.
            المطلوب: إنشاء اختبار من خمسة أسئلة متعددة الخيارات باللغة العربية حول المحتوى المقدم.
            
            المواصفات المطلوبة:
            - كل سؤال يجب أن يكون له أربعة خيارات
            - يجب تحديد إجابة صحيحة واحدة لكل سؤال
            - $difficultyPrompt
            
            يجب إرجاع النتيجة بتنسيق JSON كما يلي:
            {
              "questions": [
                {
                  "question": "نص السؤال هنا",
                  "options": [
                    "الخيار الأول",
                    "الخيار الثاني",
                    "الخيار الثالث",
                    "الخيار الرابع"
                  ],
                  "answer": "الإجابة الصحيحة هنا"
                }
              ]
            }'''
            },
            {
              'role': 'user',
              'content': 'قم بإنشاء اختبار حول المحتوى التالي:\n$courseContent'
            }
          ],
          'temperature': 0.3, // Reduced temperature for more consistent output
          'max_tokens': 2000, // Ensure enough tokens for response
        }),
      );

      developer.log('API response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];

        developer.log('Received content from API: $content');

        try {
          developer.log('Attempting to parse JSON response');
          final quizJson = jsonDecode(content);

          if (!quizJson.containsKey('questions') ||
              !(quizJson['questions'] is List)) {
            developer.log('Invalid JSON structure: ${quizJson.toString()}');
            throw FormatException('Invalid quiz JSON structure');
          }

          final questions = (quizJson['questions'] as List).map((q) {
            if (!q.containsKey('question') ||
                !q.containsKey('options') ||
                !q.containsKey('answer')) {
              developer.log('Invalid question format: ${q.toString()}');
              throw FormatException('Invalid question format');
            }

            return Question(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              questionText: q['question'] as String,
              choices: List<String>.from(q['options']),
              correctAnswer: q['answer'] as String,
            );
          }).toList();

          developer.log('Successfully created ${questions.length} questions');

          if (questions.isEmpty) {
            throw Exception('No questions were generated');
          }

          return Quiz(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'اختبار تقييمي',
            questions: questions,
          );
        } catch (e) {
          developer.log(
              'Error parsing JSON response: $e. Attempting plain text parsing.');
          return _parsePlainTextQuiz(content);
        }
      } else {
        developer.log('API request failed with status: ${response.statusCode}');
        developer.log('Response body: ${response.body}');
        throw Exception('Failed to generate quiz: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      developer.log('Error in generateQuiz: $e');
      developer.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Quiz _parsePlainTextQuiz(String content) {
    developer.log('Starting plain text parsing');
    final List<Question> questions = [];

    // Split content into questions
    final questionBlocks = content
        .split(RegExp(r'(?=السؤال|^\d+[\-\.])'))
        .where((block) => block.trim().isNotEmpty)
        .toList();

    developer.log('Found ${questionBlocks.length} question blocks');

    for (var block in questionBlocks) {
      try {
        // Extract question text
        final questionMatch =
            RegExp(r'^(?:السؤال\s*\d+:?\s*)?(.+?)\s*(?=[أاإ]\.)', dotAll: true)
                .firstMatch(block);
        if (questionMatch == null) continue;

        final questionText = questionMatch.group(1)?.trim() ?? '';

        // Extract choices
        final choicesPattern =
            RegExp(r'([أاإبجد])\.([^أاإبجد]+)(?=[أاإبجد]\.|$)', dotAll: true);
        final choicesMatches = choicesPattern.allMatches(block);

        if (choicesMatches.length < 4) continue;

        final choices = List<String>.filled(4, '');
        for (var match in choicesMatches) {
          final option = match.group(1);
          final text = match.group(2)?.trim() ?? '';

          switch (option) {
            case 'أ':
            case 'ا':
            case 'إ':
              choices[0] = text;
              break;
            case 'ب':
              choices[1] = text;
              break;
            case 'ج':
              choices[2] = text;
              break;
            case 'د':
              choices[3] = text;
              break;
          }
        }

        // Extract correct answer
        final answerMatch =
            RegExp(r'(?:الإجابة|الاجابة|الجواب)\s*(?:الصحيحة)?[\s:]*([أاإبجد])')
                .firstMatch(block);
        String correctAnswer = choices[0]; // Default to first choice

        if (answerMatch != null) {
          final answerLetter = answerMatch.group(1);
          switch (answerLetter) {
            case 'أ':
            case 'ا':
            case 'إ':
              correctAnswer = choices[0];
              break;
            case 'ب':
              correctAnswer = choices[1];
              break;
            case 'ج':
              correctAnswer = choices[2];
              break;
            case 'د':
              correctAnswer = choices[3];
              break;
          }
        }

        questions.add(Question(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          questionText: questionText,
          choices: choices,
          correctAnswer: correctAnswer,
        ));

        developer.log('Successfully parsed question: $questionText');
      } catch (e) {
        developer.log('Error parsing question block: $e');
        continue;
      }
    }

    developer.log('Finished parsing. Generated ${questions.length} questions');

    return Quiz(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'اختبار تقييمي',
      questions: questions,
    );
  }
}
