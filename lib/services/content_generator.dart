// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';
// import 'dart:developer' as developer;
// import '../data/level_years.dart';

// class ContentGeneratorService {
//   final String apiKey;
//   final String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   ContentGeneratorService(this.apiKey);

//   Future<void> generateAndInitializeContent(
//     String level,
//     String year, {
//     String? department,
//   }) async {
//     print(
//         'Starting content generation for $level - $year (Department: $department)');
//     try {
//       final structure = _getStructureForYear(level, year);
//       final semesterStructure =
//           await _generateSemesterStructure(level, year, department, structure);
//       await _initializeContentInFirestore(
//           level, year, department, semesterStructure);
//       print('Content generation and initialization completed successfully');
//     } catch (e) {
//       print('Error in generateAndInitializeContent: $e');
//       rethrow;
//     }
//   }

//   String _getStructureForYear(String level, String year) {
//     final levelData = educationSystem[level];
//     if (levelData == null) {
//       throw Exception('Level $level not found in education system');
//     }

//     final yearData = levelData.years[year];
//     if (yearData == null) {
//       throw Exception('Year $year not found in level $level');
//     }

//     // Get the structure from the first semester (assuming all semesters have the same structure)
//     final semester = yearData.semesters?.first;
//     if (semester == null) {
//       throw Exception('No semesters found for year $year in level $level');
//     }

//     return semester.structure;
//   }

//   Future<List<Map<String, dynamic>>> _generateSemesterStructure(
//     String level,
//     String year,
//     String? department,
//     String structure,
//   ) async {
//     try {
//       final prompt = _buildPrompt(level, year, department, structure);

//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: jsonEncode({
//           'model': 'llama-3.3-70b-versatile',
//           'messages': [
//             {
//               'role': 'system',
//               'content': prompt,
//             }
//           ],
//           'temperature': 0.7,
//           'max_tokens': 4000,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(utf8.decode(response.bodyBytes));
//         final content = data['choices'][0]['message']['content'];

//         try {
//           return _parseGeneratedContent(content);
//         } catch (e) {
//           developer.log('Error parsing generated content: $e');
//           throw FormatException('Invalid content structure');
//         }
//       } else {
//         throw Exception('Failed to generate content: ${response.statusCode}');
//       }
//     } catch (e) {
//       developer.log('Error in _generateSemesterStructure: $e');
//       rethrow;
//     }
//   }

//   String _buildPrompt(
//     String level,
//     String year,
//     String? department,
//     String structure,
//   ) {
//     return '''أنت خبير في تصميم المناهج التعليمية للتاريخ في الجزائر.
//   المطلوب: إنشاء محتوى تعليمي كامل للمستوى: $level، السنة: $year${department != null ? '، التخصص: $department' : ''}

//   المواصفات المطلوبة:
//   - يجب أن يغطي المحتوى الهيكل التالي:
//   $structure
//   - كل درس يجب أن يحتوي على محتوى تعليمي كامل بتنسيق Markdown.
//   - يجب أن يكون المحتوى مناسباً للمستوى التعليمي.
//   - استخدام العناوين الرئيسية (#) والعناوين الفرعية (##) والنقاط (* أو 1.) لتنظيم المحتوى.
//   - يجب فصل كل درس إلى بطاقات تعليمية (flashcards) باستخدام ---.

//   مثال على تنسيق الدرس:
//   # حضارة نوميديا القديمة

//   ## التعريف بالحضارة النوميدية
//   * مملكة نوميديا القديمة
//   * موقعها الجغرافي
//   * أهم ملوكها

//   ## الحياة الاجتماعية
//   1. العادات والتقاليد
//   2. نظام الحكم
//   3. الحياة اليومية

//   ---

//   # التراث النوميدي

//   ## المعالم الأثرية
//   * الضريح الملكي المدغاسن
//   * مدينة تيمقاد الرومانية
//   * قصر ماسينيسا

//   ## الفنون والصناعات
//   - صناعة الفخار
//   - النقوش الصخرية
//   - صناعة الحلي

//   يجب إرجاع النتيجة بتنسيق JSON كما يلي:
//   {
//     "semesters": [
//       {
//         "name": "اسم الفصل الدراسي",
//         "chapters": [
//           {
//             "name": "اسم الفصل",
//             "backgroundImage": "assets/images/chapter1.png",
//             "courses": [
//               {
//                 "name": "اسم الدرس",
//                 "content": "المحتوى بتنسيق Markdown"
//               }
//             ]
//           }
//         ]
//       }
//     ]
//   }''';
//   }

//   List<Map<String, dynamic>> _parseGeneratedContent(String content) {
//     final jsonContent = jsonDecode(content);

//     if (!jsonContent.containsKey('semesters') ||
//         !(jsonContent['semesters'] is List)) {
//       throw FormatException('Invalid JSON structure');
//     }

//     return List<Map<String, dynamic>>.from(jsonContent['semesters']);
//   }

//   Future<void> _initializeContentInFirestore(
//     String level,
//     String year,
//     String? department,
//     List<Map<String, dynamic>> semesters,
//   ) async {
//     try {
//       final batch = _firestore.batch();
//       final levelRef = _firestore.collection('education').doc(level);
//       final yearRef = levelRef.collection('years').doc(year);

//       // Create or update year document
//       batch.set(
//           yearRef,
//           {
//             'name': year,
//             'departments': department != null ? [department] : ['none'],
//             'lastUpdated': FieldValue.serverTimestamp(),
//           },
//           SetOptions(merge: true));

//       // Add semesters and their content
//       for (var semester in semesters) {
//         final semesterRef =
//             yearRef.collection('semesters').doc(semester['name']);
//         batch.set(semesterRef, {'name': semester['name']});

//         for (var chapter in semester['chapters']) {
//           final chapterRef = semesterRef.collection('chapters').doc();
//           batch.set(chapterRef, {
//             'name': chapter['name'],
//             'backgroundImage': chapter['backgroundImage'],
//           });

//           for (var course in chapter['courses']) {
//             final courseRef = chapterRef.collection('courses').doc();
//             batch.set(courseRef, {
//               'name': course['name'],
//               'content': course['content'],
//               'createdAt': FieldValue.serverTimestamp(),
//             });
//           }
//         }
//       }

//       await batch.commit();
//       developer.log('Content initialized in Firestore successfully');
//     } catch (e) {
//       developer.log('Error initializing content in Firestore: $e');
//       throw e;
//     }
//   }

//   Future<bool> isContentInitialized(
//     String level,
//     String year, {
//     String? department,
//   }) async {
//     try {
//       final yearRef = _firestore
//           .collection('education')
//           .doc(level)
//           .collection('years')
//           .doc(year);

//       final yearDoc = await yearRef.get();
//       if (!yearDoc.exists) return false;

//       final semestersSnapshot = await yearRef.collection('semesters').get();
//       return semestersSnapshot.docs.isNotEmpty;
//     } catch (e) {
//       developer.log('Error checking content initialization status: $e');
//       return false;
//     }
//   }
// }

// // import 'package:http/http.dart' as http;
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'dart:convert';
// // import 'dart:developer' as developer;
// // import '../data/education_system.dart';
// // import '../data/level_years.dart';

// // class ContentGeneratorService {
// //   final String apiKey;
// //   final String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   ContentGeneratorService(this.apiKey);

// //   Future<void> generateAndInitializeContent(
// //     String level,
// //     String year, {
// //     String? department,
// //   }) async {
// //     try {
// //       developer.log(
// //           'Starting content generation for $level - $year ${department ?? ''}');

// //       // Check if default content exists in level_years.dart
// //       final defaultContent = _getDefaultContent(level, year, department);

// //       List<Map<String, dynamic>> semesterStructure;
// //       if (defaultContent != null) {
// //         // Use default content if available
// //         semesterStructure = _convertDefaultContentToStructure(defaultContent);
// //       } else {
// //         // Generate content using LLM if no default content exists
// //         semesterStructure =
// //             await _generateSemesterStructure(level, year, department);
// //       }

// //       await _initializeContentInFirestore(
// //           level, year, department, semesterStructure);
// //       developer
// //           .log('Content generation and initialization completed successfully');
// //     } catch (e) {
// //       developer.log('Error in generateAndInitializeContent: $e');
// //       rethrow;
// //     }
// //   }

// //   YearStructure? _getDefaultContent(
// //       String level, String year, String? department) {
// //     try {
// //       return educationSystem[level]?.years[year];
// //     } catch (e) {
// //       developer.log('Error getting default content: $e');
// //       return null;
// //     }
// //   }

// //   List<Map<String, dynamic>> _convertDefaultContentToStructure(
// //       YearStructure yearStructure) {
// //     return yearStructure.semesters.map((semester) {
// //       return {
// //         'name': semester.name,
// //         'chapters': semester.chapters.map((chapter) {
// //           return {
// //             'name': chapter.name,
// //             'backgroundImage': chapter.backgroundImage,
// //             'courses': chapter.courses.map((course) {
// //               // Split content by '---' to separate flashcards
// //               final List<String> sections = course.content.split('---');
// //               final processedContent =
// //                   sections.map((section) => section.trim()).join('\n\n---\n\n');

// //               return {
// //                 'name': course.name,
// //                 'content': processedContent,
// //               };
// //             }).toList(),
// //           };
// //         }).toList(),
// //       };
// //     }).toList();
// //   }

// //   Future<List<Map<String, dynamic>>> _generateSemesterStructure(
// //     String level,
// //     String year,
// //     String? department,
// //   ) async {
// //     try {
// //       final prompt = _buildPrompt(level, year, department);
// //       final response = await http.post(
// //         Uri.parse(baseUrl),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $apiKey',
// //         },
// //         body: jsonEncode({
// //           'model': 'llama-3.3-70b-versatile',
// //           'messages': [
// //             {
// //               'role': 'system',
// //               'content': prompt,
// //             }
// //           ],
// //           'temperature': 0.7,
// //           'max_tokens': 4000,
// //         }),
// //       );

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(utf8.decode(response.bodyBytes));
// //         final content = data['choices'][0]['message']['content'];
// //         return _parseGeneratedContent(content);
// //       } else {
// //         throw Exception('Failed to generate content: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       developer.log('Error in _generateSemesterStructure: $e');
// //       rethrow;
// //     }
// //   }

// //   List<Map<String, dynamic>> _parseGeneratedContent(String content) {
// //     try {
// //       // Parse the JSON content
// //       final Map<String, dynamic> jsonContent = jsonDecode(content);

// //       // Validate the structure
// //       if (!jsonContent.containsKey('semesters') ||
// //           jsonContent['semesters'] is! List) {
// //         throw FormatException(
// //             'Invalid JSON structure: missing or invalid semesters array');
// //       }

// //       // Convert to List<Map<String, dynamic>>
// //       final List<dynamic> semestersJson = jsonContent['semesters'];

// //       return semestersJson.map<Map<String, dynamic>>((semester) {
// //         // Validate semester structure
// //         if (!semester.containsKey('name') ||
// //             !semester.containsKey('chapters') ||
// //             !(semester['chapters'] is List)) {
// //           throw FormatException('Invalid semester structure');
// //         }

// //         return {
// //           'name': semester['name'] as String,
// //           'chapters': (semester['chapters'] as List).map((chapter) {
// //             // Validate chapter structure
// //             if (!chapter.containsKey('name') ||
// //                 !chapter.containsKey('backgroundImage') ||
// //                 !chapter.containsKey('courses') ||
// //                 !(chapter['courses'] is List)) {
// //               throw FormatException('Invalid chapter structure');
// //             }

// //             return {
// //               'name': chapter['name'] as String,
// //               'backgroundImage': chapter['backgroundImage'] as String,
// //               'courses': (chapter['courses'] as List).map((course) {
// //                 // Validate course structure
// //                 if (!course.containsKey('name') ||
// //                     !course.containsKey('content')) {
// //                   throw FormatException('Invalid course structure');
// //                 }

// //                 // Process content and split into flashcards if needed
// //                 String content = course['content'] as String;
// //                 if (!content.contains('---')) {
// //                   // If no flashcard separators found, treat entire content as one flashcard
// //                   content = content.trim();
// //                 }

// //                 return {
// //                   'name': course['name'] as String,
// //                   'content': content,
// //                 };
// //               }).toList(),
// //             };
// //           }).toList(),
// //         };
// //       }).toList();
// //     } catch (e) {
// //       developer.log('Error parsing generated content: $e');
// //       throw FormatException(
// //           'Failed to parse generated content: ${e.toString()}');
// //     }
// //   }

// //   String _buildPrompt(String level, String year, String? department) {
// //     return '''أنت خبير في تصميم المناهج التعليمية للتاريخ في الجزائر.
// //     المطلوب: إنشاء محتوى تعليمي كامل للمستوى: $level، السنة: $year${department != null ? '، التخصص: $department' : ''}

// //     المواصفات المطلوبة:
// //     - الدروس مقسمة على شكل 
// //     - كل درس يجب أن يتكون من عدة بطاقات تعليمية (flashcards) مفصولة بـ ---
// //     - كل بطاقة تعليمية تحتوي على عنوان رئيسي، عناوين فرعية، ونقاط تعليمية
// //     - استخدام تنسيق Markdown للمحتوى
// //     - المحتوى يجب أن يكون مناسباً للمستوى التعليمي
    
// //     مثال على تنسيق البطاقة التعليمية:
// //     # الوحدة الأولى
    
// //     ## الوضعية الأولى
// //     * نقطة 1
// //     * نقطة 2
    
// //     ## الوضعية الثانية
// //     * نقطة 1
// //     * نقطة 2
    
// //     ---
    
// //     # الوحدة الثانية
// //     ...
// //     ''';
// //   }

// //   Future<void> _initializeContentInFirestore(
// //     String level,
// //     String year,
// //     String? department,
// //     List<Map<String, dynamic>> semesters,
// //   ) async {
// //     try {
// //       final batch = _firestore.batch();
// //       final levelRef = _firestore.collection('education').doc(level);
// //       final yearRef = levelRef.collection('years').doc(year);

// //       // Create or update year document
// //       batch.set(
// //         yearRef,
// //         {
// //           'name': year,
// //           'departments': department != null ? [department] : ['none'],
// //           'lastUpdated': FieldValue.serverTimestamp(),
// //         },
// //         SetOptions(merge: true),
// //       );

// //       // Add semesters and their content
// //       for (var semester in semesters) {
// //         final semesterRef =
// //             yearRef.collection('semesters').doc(semester['name']);
// //         batch.set(semesterRef, {'name': semester['name']});

// //         for (var chapter in semester['chapters']) {
// //           final chapterRef = semesterRef.collection('chapters').doc();
// //           batch.set(chapterRef, {
// //             'name': chapter['name'],
// //             'backgroundImage': chapter['backgroundImage'],
// //           });

// //           for (var course in chapter['courses']) {
// //             final courseRef = chapterRef.collection('courses').doc();
// //             batch.set(courseRef, {
// //               'name': course['name'],
// //               'content': course['content'],
// //               'createdAt': FieldValue.serverTimestamp(),
// //               'flashcards': _extractFlashcards(course['content']),
// //             });
// //           }
// //         }
// //       }

// //       await batch.commit();
// //       developer.log('Content initialized in Firestore successfully');
// //     } catch (e) {
// //       developer.log('Error initializing content in Firestore: $e');
// //       throw e;
// //     }
// //   }

// //   List<Map<String, String>> _extractFlashcards(String content) {
// //     final List<String> sections = content.split('---');
// //     return sections.map((section) {
// //       return {
// //         'content': section.trim(),
// //       };
// //     }).toList();
// //   }
// // }
