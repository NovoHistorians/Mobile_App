// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../data/education_system.dart';
// import '../data/level_years.dart';
// import 'content_generator.dart';

// class FirebaseInitService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ContentGeneratorService _contentGenerator;

//   FirebaseInitService(String apiKey)
//       : _contentGenerator = ContentGeneratorService(apiKey);

//   Future<void> initializeEducationContent() async {
//     try {
//       // Check if initialization has already been done
//       if (await isDatabaseInitialized()) {
//         print('Database already initialized');
//         return;
//       }

//       final batch = _firestore.batch();

//       // Initialize education levels
//       for (var levelEntry in educationSystem.entries) {
//         await _initializeLevel(levelEntry.key, levelEntry.value);
//       }

//       print('Education content initialized successfully');

//       // Mark initialization as complete
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('database_initialized', true);
//     } catch (e) {
//       print('Error initializing education content: $e');
//       throw e;
//     }
//   }

//   Future<void> initializeYearContent(String level, String year) async {
//     try {
//       final levelData = educationSystem[level];
//       if (levelData == null) {
//         throw Exception('Level $level not found in education system');
//       }

//       final yearData = levelData.years[year];
//       if (yearData == null) {
//         throw Exception('Year $year not found in level $level');
//       }

//       final levelRef = _firestore.collection('education').doc(level);
//       await _initializeYear(levelRef, year, yearData);

//       print('Content initialized successfully for $level - $year');
//     } catch (e) {
//       print('Error initializing content for $level - $year: $e');
//       throw e;
//     }
//   }

//   Future<void> _initializeLevel(String levelKey, EducationLevel level) async {
//     try {
//       final levelRef = _firestore.collection('education').doc(levelKey);
//       await levelRef.set({'name': level.name});

//       // Initialize years for this level
//       for (var yearEntry in level.years.entries) {
//         await _initializeYear(levelRef, yearEntry.key, yearEntry.value);
//       }
//     } catch (e) {
//       print('Error initializing level $levelKey: $e');
//       throw e;
//     }
//   }

//   Future<void> _initializeYear(
//     DocumentReference levelRef,
//     String yearKey,
//     YearStructure year,
//   ) async {
//     try {
//       final yearRef = levelRef.collection('years').doc(yearKey);

//       // Set basic year information
//       await yearRef.set({
//         'name': year.name,
//         'departments': year.departments?.keys.toList() ?? ['none'],
//         'lastUpdated': FieldValue.serverTimestamp(),
//       });

//       // Check if we have predefined content
//       if (year.semesters != null && year.semesters!.isNotEmpty) {
//         // Initialize predefined content
//         await _initializePredefinedContent(yearRef, year);
//       } else {
//         // Generate content using LLM for years without predefined content
//         final structure = _getStructureForYear(levelRef.id, yearKey);
//         await _generateAndInitializeContent(
//           levelRef.id,
//           yearKey,
//           null, // No department for years without departments
//           structure,
//         );
//       }
//     } catch (e) {
//       print('Error initializing year $yearKey: $e');
//       throw e;
//     }
//   }

//   Future<void> _initializePredefinedContent(
//     DocumentReference yearRef,
//     YearStructure year,
//   ) async {
//     try {
//       for (var semester in year.semesters!) {
//         final semesterRef = yearRef.collection('semesters').doc(semester.name);
//         await semesterRef.set({'name': semester.name});

//         for (var chapter in semester.chapters) {
//           final chapterRef = semesterRef.collection('chapters').doc();
//           await chapterRef.set({
//             'name': chapter.name,
//             'backgroundImage': chapter.backgroundImage,
//           });

//           for (var course in chapter.courses) {
//             final courseRef = chapterRef.collection('courses').doc();

//             // Split content into flashcards
//             final List<String> flashcards = course.content
//                 .split('---')
//                 .map((content) => content.trim())
//                 .where((content) => content.isNotEmpty)
//                 .toList();

//             await courseRef.set({
//               'name': course.name,
//               'content': course.content,
//               'flashcards': flashcards
//                   .map((content) => {
//                         'content': content,
//                       })
//                   .toList(),
//               'createdAt': FieldValue.serverTimestamp(),
//             });
//           }
//         }
//       }
//     } catch (e) {
//       print('Error initializing predefined content: $e');
//       throw e;
//     }
//   }

//   Future<void> _generateAndInitializeContent(
//     String level,
//     String year,
//     String? department,
//     String structure,
//   ) async {
//     print('Generating content for $level - $year (Department: $department)');
//     try {
//       await _contentGenerator.generateAndInitializeContent(
//         level,
//         year,
//         department: department,
//       );
//     } catch (e) {
//       print('Error generating content for $level $year: $e');
//       throw e;
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

//     return semester;
//   }

//   Future<bool> isDatabaseInitialized() async {
//     try {
//       // Check SharedPreferences first for quick response
//       final prefs = await SharedPreferences.getInstance();
//       if (prefs.getBool('database_initialized') ?? false) {
//         return true;
//       }

//       // Double-check Firestore if SharedPreferences says no
//       final snapshot = await _firestore.collection('education').get();
//       final isInitialized = snapshot.docs.isNotEmpty;

//       // Update SharedPreferences if we found data
//       if (isInitialized) {
//         await prefs.setBool('database_initialized', true);
//       }

//       return isInitialized;
//     } catch (e) {
//       print('Error checking initialization status: $e');
//       return false;
//     }
//   }

//   Future<void> reinitializeContent({bool force = false}) async {
//     try {
//       if (force) {
//         // Clear initialization flag
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.remove('database_initialized');

//         // Clear existing content
//         final batch = _firestore.batch();
//         final snapshot = await _firestore.collection('education').get();
//         for (var doc in snapshot.docs) {
//           batch.delete(doc.reference);
//         }
//         await batch.commit();
//       }

//       // Reinitialize content
//       await initializeEducationContent();
//     } catch (e) {
//       print('Error reinitializing content: $e');
//       throw e;
//     }
//   }
// }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../data/education_system.dart';
// // import '../data/level_years.dart';
// // import 'content_generator.dart';

// // class FirebaseInitService {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final ContentGeneratorService _contentGenerator;

// //   FirebaseInitService(String apiKey)
// //       : _contentGenerator = ContentGeneratorService(apiKey);

// //   Future<void> initializeEducationContent() async {
// //     try {
// //       // Check if initialization has already been done
// //       if (await isDatabaseInitialized()) {
// //         print('Database already initialized');
// //         return;
// //       }

// //       final batch = _firestore.batch();

// //       // Initialize education levels
// //       for (var levelEntry in educationSystem.entries) {
// //         await _initializeLevel(levelEntry.key, levelEntry.value);
// //       }

// //       print('Education content initialized successfully');

// //       // Mark initialization as complete
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setBool('database_initialized', true);
// //     } catch (e) {
// //       print('Error initializing education content: $e');
// //       throw e;
// //     }
// //   }

// //   Future<void> _initializeLevel(String levelKey, EducationLevel level, String structure) async {
// //     try {
// //       final levelRef = _firestore.collection('education').doc(levelKey);
// //       await levelRef.set({'name': level.name});

// //       // Initialize years for this level
// //       for (var yearEntry in level.years.entries) {
// //         await _initializeYear(levelRef, yearEntry.key, yearEntry.value, structure);
// //       }
// //     } catch (e) {
// //       print('Error initializing level $levelKey: $e');
// //       throw e;
// //     }
// //   }

// //   Future<void> _initializeYear(
// //     DocumentReference levelRef,
// //     String yearKey,
// //     YearStructure year,
// //     String structure
// //   ) async {
// //     try {
// //       final yearRef = levelRef.collection('years').doc(yearKey);

// //       // Set basic year information
// //       await yearRef.set({
// //         'name': year.name,
// //         'departments': year.departments,
// //         'lastUpdated': FieldValue.serverTimestamp(),
// //       });

// //       // Check if we have predefined content
// //       if (year.semesters.isNotEmpty) {
// //         await _initializePredefinedContent(yearRef, year);
// //       } else {
// //         // Generate content using LLM
// //         await _generateAndInitializeContent(
// //           levelRef.id,
// //           yearKey,
// //           year.departments.contains('none') ? null : year.departments.first,
// //           structure
// //         );
// //       }
// //     } catch (e) {
// //       print('Error initializing year $yearKey: $e');
// //       throw e;
// //     }
// //   }

// //   Future<void> _initializePredefinedContent(
// //     DocumentReference yearRef,
// //     YearStructure year,
// //   ) async {
// //     try {
// //       for (var semester in year.semesters) {
// //         final semesterRef = yearRef.collection('semesters').doc(semester.name);
// //         await semesterRef.set({'name': semester.name});

// //         for (var chapter in semester.chapters) {
// //           final chapterRef = semesterRef.collection('chapters').doc();
// //           await chapterRef.set({
// //             'name': chapter.name,
// //             'backgroundImage': chapter.backgroundImage,
// //           });

// //           for (var course in chapter.courses) {
// //             final courseRef = chapterRef.collection('courses').doc();

// //             // Split content into flashcards
// //             final List<String> flashcards = course.content
// //                 .split('---')
// //                 .map((content) => content.trim())
// //                 .where((content) => content.isNotEmpty)
// //                 .toList();

// //             await courseRef.set({
// //               'name': course.name,
// //               'content': course.content,
// //               'flashcards': flashcards
// //                   .map((content) => {
// //                         'content': content,
// //                       })
// //                   .toList(),
// //               'createdAt': FieldValue.serverTimestamp(),
// //             });
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       print('Error initializing predefined content: $e');
// //       throw e;
// //     }
// //   }

// //   Future<void> _generateAndInitializeContent(
// //     String level,
// //     String year,
// //     String? department,
// //     String structure,
// //   ) async {
// //     try {
// //       await _contentGenerator.generateAndInitializeContent(
// //         level,
// //         year,
// //         structure,
// //         department: department,
// //       );
// //     } catch (e) {
// //       print('Error generating content for $level $year: $e');
// //       throw e;
// //     }
// //   }

// //   Future<bool> isDatabaseInitialized() async {
// //     try {
// //       // Check SharedPreferences first for quick response
// //       final prefs = await SharedPreferences.getInstance();
// //       if (prefs.getBool('database_initialized') ?? false) {
// //         return true;
// //       }

// //       // Double-check Firestore if SharedPreferences says no
// //       final snapshot = await _firestore.collection('education').get();
// //       final isInitialized = snapshot.docs.isNotEmpty;

// //       // Update SharedPreferences if we found data
// //       if (isInitialized) {
// //         await prefs.setBool('database_initialized', true);
// //       }

// //       return isInitialized;
// //     } catch (e) {
// //       print('Error checking initialization status: $e');
// //       return false;
// //     }
// //   }

// //   Future<void> reinitializeContent({bool force = false}) async {
// //     try {
// //       if (force) {
// //         // Clear initialization flag
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.remove('database_initialized');

// //         // Clear existing content
// //         final batch = _firestore.batch();
// //         final snapshot = await _firestore.collection('education').get();
// //         for (var doc in snapshot.docs) {
// //           batch.delete(doc.reference);
// //         }
// //         await batch.commit();
// //       }

// //       // Reinitialize content
// //       await initializeEducationContent();
// //     } catch (e) {
// //       print('Error reinitializing content: $e');
// //       throw e;
// //     }
// //   }
// // }
