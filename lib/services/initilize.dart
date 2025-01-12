import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/level_years.dart';
import 'test_2.dart'; // Assuming this contains ContentGenerationService

class DatabaseInitializationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ContentGenerationService _contentGenerationService;

  DatabaseInitializationService({
    required ContentGenerationService contentGenerationService,
  }) : _contentGenerationService = contentGenerationService;

  Future<void> initializeDatabase() async {
    try {
      // Check if the database has already been initialized
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('database_initialized') ?? false) {
        print('Database already initialized');
        return;
      }

      // Use a batch to group all Firestore writes
      final batch = _firestore.batch();

      // Iterate through the education system data
      for (var levelEntry in educationSystem.entries) {
        final levelName = levelEntry.key;
        final level = levelEntry.value;

        // Create a reference for the education level
        final levelRef = _firestore.collection('education').doc(levelName);
        batch.set(levelRef, {'name': level.name});

        // Iterate through years
        for (var yearEntry in level.years.entries) {
          final yearName = yearEntry.key;
          final year = yearEntry.value;

          // Create a reference for the year
          final yearRef = levelRef.collection('years').doc(yearName);
          batch.set(yearRef, {
            'name': year.name,
            'departments': year.departments != null,
          });

          // Handle semesters if they exist
          if (year.semesters != null) {
            for (var semester in year.semesters!) {
              final semesterRef =
                  yearRef.collection('semesters').doc(semester.name);
              batch.set(semesterRef, {'name': semester.name});

              // Handle chapters
              for (var chapter in semester.chapters) {
                final chapterRef = semesterRef.collection('chapters').doc();
                batch.set(chapterRef, {
                  'name': chapter.name,
                  'backgroundImage': chapter.backgroundImage,
                });

                // Handle courses
                for (var course in chapter.courses) {
                  // Generate content for the course
                  final content =
                      await _contentGenerationService.generateCourseContent(
                    chapter.name,
                    course.name,
                  );

                  if (content != null) {
                    course.content = content;
                    final courseRef = chapterRef.collection('courses').doc();
                    batch.set(courseRef, {
                      'name': course.name,
                      'content': course.content,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                  } else {
                    print(
                        'Failed to generate content for course: ${course.name}');
                  }
                }
              }
            }
          }

          // Handle departments if they exist
          if (year.departments != null) {
            for (var departmentEntry in year.departments!.entries) {
              final departmentName = departmentEntry.key;
              final semesters = departmentEntry.value;

              // Create a reference for the department
              final departmentRef =
                  yearRef.collection('departments').doc(departmentName);
              batch.set(departmentRef, {'name': departmentName});

              // Handle semesters within the department
              for (var semester in semesters) {
                final semesterRef =
                    departmentRef.collection('semesters').doc(semester.name);
                batch.set(semesterRef, {'name': semester.name});

                // Handle chapters
                for (var chapter in semester.chapters) {
                  final chapterRef = semesterRef.collection('chapters').doc();
                  batch.set(chapterRef, {
                    'name': chapter.name,
                    'backgroundImage': chapter.backgroundImage,
                  });

                  // Handle courses
                  for (var course in chapter.courses) {
                    // Generate content for the course
                    final content =
                        await _contentGenerationService.generateCourseContent(
                      chapter.name,
                      course.name,
                    );

                    if (content != null) {
                      course.content = content;
                      final courseRef = chapterRef.collection('courses').doc();
                      batch.set(courseRef, {
                        'name': course.name,
                        'content': course.content,
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                    } else {
                      print(
                          'Failed to generate content for course: ${course.name}');
                    }
                  }
                }
              }
            }
          }
        }
      }

      // Commit the batch
      await batch.commit();

      // Mark the database as initialized
      await prefs.setBool('database_initialized', true);
      print('Database initialized successfully');
    } catch (e) {
      print('Error initializing database: $e');
      throw e; // Re-throw the error for further handling
    }
  }

  Future<bool> isDatabaseInitialized() async {
    try {
      // Check SharedPreferences first for quick response
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('database_initialized') ?? false) {
        return true;
      }

      // Double-check Firestore if SharedPreferences says no
      final snapshot = await _firestore.collection('education').get();
      final isInitialized = snapshot.docs.isNotEmpty;

      // Update SharedPreferences if we found data
      if (isInitialized) {
        await prefs.setBool('database_initialized', true);
      }

      return isInitialized;
    } catch (e) {
      print('Error checking initialization status: $e');
      return false;
    }
  }
}
