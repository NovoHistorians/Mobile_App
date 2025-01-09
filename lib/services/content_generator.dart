import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class ContentGeneratorService {
  final String apiKey;
  final String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ContentGeneratorService(this.apiKey);

  Future<void> generateAndInitializeContent(
    String level,
    String year, {
    String? department,
  }) async {
    try {
      developer.log(
          'Starting content generation for $level - $year ${department ?? ''}');

      final semesterStructure =
          await _generateSemesterStructure(level, year, department);
      await _initializeContentInFirestore(
          level, year, department, semesterStructure);

      developer
          .log('Content generation and initialization completed successfully');
    } catch (e) {
      developer.log('Error in generateAndInitializeContent: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _generateSemesterStructure(
    String level,
    String year,
    String? department,
  ) async {
    try {
      final prompt = _buildPrompt(level, year, department);

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 4000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];

        try {
          return _parseGeneratedContent(content);
        } catch (e) {
          developer.log('Error parsing generated content: $e');
          throw FormatException('Invalid content structure');
        }
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error in _generateSemesterStructure: $e');
      rethrow;
    }
  }

  String _buildPrompt(String level, String year, String? department) {
    return '''أنت خبير في تصميم المناهج التعليمية للتاريخ في الجزائر.
    المطلوب: إنشاء محتوى تعليمي كامل للمستوى: $level، السنة: $year${department != null ? '، التخصص: $department' : ''}

    المواصفات المطلوبة:
    - فصلين دراسيين
    - كل فصل يحتوي على 3-4 فصول
    - كل فصل يحتوي على 2-3 دروس
    - كل درس يجب أن يحتوي على محتوى تعليمي كامل بتنسيق Markdown
    - المحتوى يجب أن يكون مناسباً للمستوى التعليمي
    - استخدام العناوين والنقاط الفرعية في المحتوى
    
    يجب إرجاع النتيجة بتنسيق JSON كما يلي:
    {
      "semesters": [
        {
          "name": "اسم الفصل الدراسي",
          "chapters": [
            {
              "name": "اسم الفصل",
              "backgroundImage": "assets/images/chapter1.png",
              "courses": [
                {
                  "name": "اسم الدرس",
                  "content": "المحتوى بتنسيق Markdown"
                }
              ]
            }
          ]
        }
      ]
    }''';
  }

  List<Map<String, dynamic>> _parseGeneratedContent(String content) {
    final jsonContent = jsonDecode(content);

    if (!jsonContent.containsKey('semesters') ||
        !(jsonContent['semesters'] is List)) {
      throw FormatException('Invalid JSON structure');
    }

    return List<Map<String, dynamic>>.from(jsonContent['semesters']);
  }

  Future<void> _initializeContentInFirestore(
    String level,
    String year,
    String? department,
    List<Map<String, dynamic>> semesters,
  ) async {
    try {
      final batch = _firestore.batch();
      final levelRef = _firestore.collection('education').doc(level);
      final yearRef = levelRef.collection('years').doc(year);

      // Create or update year document
      batch.set(
          yearRef,
          {
            'name': year,
            'departments': department != null ? [department] : ['none'],
            'lastUpdated': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true));

      // Add semesters and their content
      for (var semester in semesters) {
        final semesterRef =
            yearRef.collection('semesters').doc(semester['name']);
        batch.set(semesterRef, {'name': semester['name']});

        for (var chapter in semester['chapters']) {
          final chapterRef = semesterRef.collection('chapters').doc();
          batch.set(chapterRef, {
            'name': chapter['name'],
            'backgroundImage': chapter['backgroundImage'],
          });

          for (var course in chapter['courses']) {
            final courseRef = chapterRef.collection('courses').doc();
            batch.set(courseRef, {
              'name': course['name'],
              'content': course['content'],
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
      }

      await batch.commit();
      developer.log('Content initialized in Firestore successfully');
    } catch (e) {
      developer.log('Error initializing content in Firestore: $e');
      throw e;
    }
  }

  Future<bool> isContentInitialized(
    String level,
    String year, {
    String? department,
  }) async {
    try {
      final yearRef = _firestore
          .collection('education')
          .doc(level)
          .collection('years')
          .doc(year);

      final yearDoc = await yearRef.get();
      if (!yearDoc.exists) return false;

      final semestersSnapshot = await yearRef.collection('semesters').get();
      return semestersSnapshot.docs.isNotEmpty;
    } catch (e) {
      developer.log('Error checking content initialization status: $e');
      return false;
    }
  }
}
