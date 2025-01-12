// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';
// import '../data/education_system.dart';
// import '../data/level_years.dart';

// class ContentGenerationService {
//   final String _modelApiKey;
//   final String _modelEndpoint;

//   ContentGenerationService({
//     required String modelApiKey,
//     required String modelEndpoint,
//   })  : _modelApiKey = modelApiKey,
//         _modelEndpoint = modelEndpoint;

//   Future<String> generateCourseContent({
//     required String level,
//     required String year,
//     required String unitName,
//     required String situationName,
//   }) async {
//     final prompt = '''
// قم بإنشاء محتوى تعليمي مفصل للمستوى التالي
// بالإنجليزية:
// المستوى: $level
// السنة: $year
// الوحدة: $unitName
// الموضوع: $situationName

// يجب أن يكون المحتوى:
// 1. مكتوب بتنسيق Markdown
// 2. مقسم إلى أقسام باستخدام "---"
// 3. كل قسم يجب أن يحتوي على:
//    - مفهوم أو فكرة رئيسية
//    - تعريف واضح
//    - أمثلة توضيحية
//    - معلومات تاريخية ذات صلة
// 4. مناسب للمستوى التعليمي للطلاب
// 5. يتضمن:
//    - تعريفات واضحة
//    - أمثلة من التاريخ الجزائري
//    - معلومات مرتبطة بالسياق المحلي
//    - تواريخ وأحداث مهمة
//    - شخصيات تاريخية ذات صلة

// المحتوى يجب أن يكون مناسباً للاستخدام في البطاقات التعليمية (Flashcards).''';

//     int retryCount = 0;
//     const maxRetries = 3; // Maximum number of retries
//     const initialDelay = Duration(seconds: 2); // Initial delay before retrying

//     while (retryCount < maxRetries) {
//       try {
//         print('Sending request to API with prompt:');
//         print(prompt);

//         final response = await http.post(
//           Uri.parse(_modelEndpoint),
//           headers: {
//             'Authorization': 'Bearer $_modelApiKey',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode({
//             'model': 'llama-3.1-8b-instant',
//             'messages': [
//               {
//                 'role': 'user',
//                 'content': prompt,
//               }
//             ],
//             'max_tokens': 1000,
//             'temperature': 0.7,
//           }),
//         );

//         print('API response status code: ${response.statusCode}');
//         print('API response body: ${response.body}');

//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           String generatedContent =
//               data['choices'][0]['message']['content'] ?? '';

//           if (!generatedContent.contains('---')) {
//             generatedContent = _formatContent(generatedContent);
//           }

//           return generatedContent;
//         } else if (response.statusCode == 429) {
//           // Rate limit exceeded
//           final errorData = jsonDecode(response.body);
//           final retryAfter = errorData['error']['code'] == 'rate_limit_exceeded'
//               ? Duration(seconds: 2) // Default delay
//               : Duration(seconds: int.parse(errorData['error']['retry_after']));

//           print('Rate limit exceeded. Retrying after $retryAfter seconds...');
//           await Future.delayed(retryAfter);
//           retryCount++;
//         } else {
//           throw Exception('فشل في إنشاء المحتوى: ${response.statusCode}');
//         }
//       } catch (e) {
//         print('Error generating content: $e');
//         retryCount++;
//         if (retryCount >= maxRetries) {
//           throw Exception('خطأ في إنشاء المحتوى: $e');
//         }
//         await Future.delayed(initialDelay * retryCount); // Exponential backoff
//       }
//     }

//     throw Exception('فشل في إنشاء المحتوى بعد $maxRetries محاولات');
//   }

//   String _formatContent(String content) {
//     // Ensure content is properly formatted with sections
//     final sections =
//         content.split('\n\n').where((s) => s.trim().isNotEmpty).toList();
//     return sections.join('\n---\n');
//   }

//   // Example of expected content format:
//   String get exampleContentFormat => '''
// تعريف المصطلح
// ---
// شرح تفصيلي للمفهوم مع أمثلة من التاريخ الجزائري

// الأهمية التاريخية
// ---
// توضيح أهمية الموضوع في السياق التاريخي

// الأحداث الرئيسية
// ---
// سرد الأحداث التاريخية المهمة المتعلقة بالموضوع

// الشخصيات التاريخية
// ---
// ذكر الشخصيات التاريخية المرتبطة بالموضوع وإنجازاتهم

// أثر على المجتمع
// ---
// شرح تأثير هذه الأحداث على المجتمع الجزائري''';
// }

// class EducationFirebaseService {
//   final FirebaseFirestore _firestore;
//   final ContentGenerationService _contentService;

//   EducationFirebaseService({
//     required FirebaseFirestore firestore,
//     required ContentGenerationService contentService,
//   })  : _firestore = firestore,
//         _contentService = contentService;

//   Future<void> initializeEducationSystem() async {
//     try {
//       for (var entry in educationSystem.entries) {
//         final levelName = entry.key;
//         final level = entry.value;
//         await initializeEducationLevel(levelName: levelName, level: level);
//       }
//     } catch (e) {
//       throw Exception('Error initializing education system: $e');
//     }
//   }

//   Future<void> initializeEducationLevel({
//     required String levelName,
//     required EducationLevel level,
//   }) async {
//     try {
//       print('Initializing level: $levelName');
//       for (var yearEntry in level.years.entries) {
//         final yearName = yearEntry.key;
//         final yearStructure = yearEntry.value;

//         if (yearStructure.departments != null) {
//           await _initializeYearWithDepartments(
//             levelName: levelName,
//             yearName: yearName,
//             yearStructure: yearStructure,
//           );
//         } else {
//           print(yearName);
//           await _initializeYearWithoutDepartments(
//             levelName: levelName,
//             yearName: yearName,
//             yearStructure: yearStructure,
//           );
//         }
//       }
//       print('Completed initializing level: $levelName');
//     } catch (e) {
//       print('Error initializing level $levelName: $e');
//       throw Exception('Error initializing education level: $e');
//     }
//   }

//   Future<void> _initializeYearWithDepartments({
//     required String levelName,
//     required String yearName,
//     required YearStructure yearStructure,
//   }) async {
//     for (var deptEntry in yearStructure.departments!.entries) {
//       print('Processing semester: ${deptEntry.key}');
//       final departmentName = deptEntry.key;
//       final semesters = deptEntry.value;

//       for (var semester in semesters) {
//         print('Processing semester: ${semester.name}');
//         final chapters = await _generateChaptersForSemester(
//           levelName: levelName,
//           yearName: yearName,
//           semesterStructure: semester.structure,
//         );

//         final baseRef = _firestore
//             .collection('education')
//             .doc(levelName)
//             .collection('years')
//             .doc(yearName)
//             .collection('departments')
//             .doc(departmentName)
//             .collection('semesters')
//             .doc(semester.name);

//         await _saveChaptersToFirebase(baseRef, chapters);
//       }
//     }
//   }

//   Future<void> _initializeYearWithoutDepartments({
//     required String levelName,
//     required String yearName,
//     required YearStructure yearStructure,
//   }) async {
//     for (var semester in yearStructure.semesters!) {
//       final chapters = await _generateChaptersForSemester(
//         levelName: levelName,
//         yearName: yearName,
//         semesterStructure: semester.structure,
//       );

//       final baseRef = _firestore
//           .collection('education')
//           .doc(levelName)
//           .collection('years')
//           .doc(yearName)
//           .collection('semesters')
//           .doc(semester.name);

//       await _saveChaptersToFirebase(baseRef, chapters);
//     }
//   }

//   Future<List<ChapterStructure>> _generateChaptersForSemester({
//     required String levelName,
//     required String yearName,
//     required String semesterStructure,
//   }) async {
//     final List<ChapterStructure> chapters = [];
//     final units = _parseStructure(semesterStructure);

//     if (units.isEmpty) {
//       print('No units found in semester structure');
//       return chapters;
//     }

//     for (var unit in units.entries) {
//       final courses = <CourseStructure>[];

//       for (var situation in unit.value) {
//         print(
//             'Generating content for unit: ${unit.key}, situation: $situation');
//         final content = await _contentService.generateCourseContent(
//           level: levelName,
//           year: yearName,
//           unitName: unit.key,
//           situationName: situation,
//         );

//         courses.add(CourseStructure(
//           name: situation,
//           content: content,
//         ));
//       }

//       chapters.add(ChapterStructure(
//         name: unit.key,
//         courses: courses,
//         backgroundImage: _getBackgroundImageForUnit(unit.key),
//       ));
//     }

//     print('Generated chapters:');
//     print(chapters);

//     return chapters;
//   }

//   Future<void> _saveChaptersToFirebase(
//     DocumentReference baseRef,
//     List<ChapterStructure> chapters,
//   ) async {
//     final chaptersCollection = baseRef.collection('chapters');

//     for (var chapter in chapters) {
//       final chapterDoc = await chaptersCollection.add({
//         'name': chapter.name,
//         'backgroundImage': chapter.backgroundImage,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       final coursesCollection = chapterDoc.collection('courses');
//       for (var course in chapter.courses) {
//         await coursesCollection.add({
//           'name': course.name,
//           'content': course.content,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }
//     }
//   }

//   Map<String, List<String>> _parseStructure(String structure) {
//     final Map<String, List<String>> units = {};
//     String currentUnit = '';
//     final lines = structure.split('\n');

//     print('Parsing structure:');
//     print(structure);

//     for (var line in lines) {
//       line = line.trim();
//       if (line.isEmpty) continue;

//       // Check if the line starts with "الوحدة" to identify a new unit
//       if (line.startsWith('الوحدة')) {
//         currentUnit = line.split(':')[1].trim();
//         units[currentUnit] = [];
//         print('Found unit: $currentUnit');
//       }
//       // Check if the line starts with "الوضعية" to identify a situation
//       else if (line.startsWith('الوضعية')) {
//         final situation = line.split(':')[1].trim();
//         if (currentUnit.isNotEmpty) {
//           units[currentUnit]?.add(situation);
//           print('Found situation: $situation in unit: $currentUnit');
//         }
//       }
//       // Handle cases where the situation is on a new line after "الوضعية"
//       else if (line.startsWith('-')) {
//         final situation = line.split(':')[1].trim();
//         if (currentUnit.isNotEmpty) {
//           units[currentUnit]?.add(situation);
//           print('Found situation: $situation in unit: $currentUnit');
//         }
//       }
//     }

//     print('Parsed units:');
//     print(units);

//     return units;
//   }

//   String _getBackgroundImageForUnit(String unitName) {
//     final Map<String, String> imageMap = {
//       'أدوات ومفاهيم المادة': 'assets/concepts.jpg',
//       'التاريخ العام': 'assets/general_history.jpg',
//       'التاريخ الوطني': 'assets/national_history.jpg',
//       // Add more mappings as needed
//     };

//     return imageMap[unitName] ?? 'assets/default_background.jpg';
//   }
// }
