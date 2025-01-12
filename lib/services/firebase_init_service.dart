import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/level_years.dart';
import 'content_generator.dart'; // Assuming this contains ContentGenerationService

class DatabaseInitializationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ContentGenerationService _contentGenerationService;

  DatabaseInitializationService({
    required ContentGenerationService contentGenerationService,
  }) : _contentGenerationService = contentGenerationService;

  String formatNumberAsString(int number, {String prefix = ''}) {
    return '$prefix$number';
  }

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
            'departments': year.departments != null
                ? year.departments!
                    .map((k, v) => MapEntry(k, v.map((s) => s.name).toList()))
                : null,
          });

          // Handle semesters if they exist
          if (year.semesters != null) {
            for (var semester in year.semesters!) {
              final semesterRef =
                  yearRef.collection('semesters').doc(semester.name);
              batch.set(semesterRef, {'name': semester.name});

              int chapterNumber = 1;

              // Handle chapters
              for (var chapter in semester.chapters) {
                final chapterRef = semesterRef.collection('chapters').doc();
                batch.set(chapterRef, {
                  'name': chapter.name,
                  'backgroundImage': chapter.backgroundImage,
                  'number':
                      formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
                });

                int courseNumber = 1;

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
                      'number': formatNumberAsString(courseNumber,
                          prefix: 'الوضعية '),
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    courseNumber++;
                  } else {
                    print(
                        'Failed to generate content for course: ${course.name}');
                  }
                }
                chapterNumber++;
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

                int chapterNumber = 1;

                // Handle chapters
                for (var chapter in semester.chapters) {
                  final chapterRef = semesterRef.collection('chapters').doc();
                  batch.set(chapterRef, {
                    'name': chapter.name,
                    'backgroundImage': chapter.backgroundImage,
                    'number':
                        formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
                  });

                  int courseNumber = 1;

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
                        'number': formatNumberAsString(courseNumber,
                            prefix: 'الوضعية '),
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                      courseNumber++;
                    } else {
                      print(
                          'Failed to generate content for course: ${course.name}');
                    }
                  }
                  chapterNumber++;
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

  Future<void> initializeSpecificLevel(String levelName) async {
    try {
      final level = educationSystem[levelName];
      if (level == null) {
        throw Exception('Level $levelName not found in education system');
      }

      final batch = _firestore.batch();

      // Create a reference for the education level
      final levelRef = _firestore.collection('education').doc(levelName);
      batch.set(levelRef, {'name': level.name});

      // Iterate through years in the level
      for (var yearEntry in level.years.entries) {
        final yearName = yearEntry.key;
        final year = yearEntry.value;

        // Create a reference for the year
        final yearRef = levelRef.collection('years').doc(yearName);
        batch.set(yearRef, {
          'name': year.name,
          'departments': year.departments != null
              ? year.departments!
                  .map((k, v) => MapEntry(k, v.map((s) => s.name).toList()))
              : null,
        });

        // Handle semesters if they exist
        if (year.semesters != null) {
          for (var semester in year.semesters!) {
            final semesterRef =
                yearRef.collection('semesters').doc(semester.name);
            batch.set(semesterRef, {'name': semester.name});

            // Initialize chapter number counter
            int chapterNumber = 1;

            // Handle chapters
            for (var chapter in semester.chapters) {
              final chapterRef = semesterRef.collection('chapters').doc();
              batch.set(chapterRef, {
                'name': chapter.name,
                'backgroundImage': chapter.backgroundImage,
                'number':
                    formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
              });

              // Initialize course number counter
              int courseNumber = 1;

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
                    'number':
                        formatNumberAsString(courseNumber, prefix: 'الوضعية '),
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  courseNumber++;
                } else {
                  print(
                      'Failed to generate content for course: ${course.name}');
                }
              }
              chapterNumber++;
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

              // Initialize chapter number counter
              int chapterNumber = 1;

              // Handle chapters
              for (var chapter in semester.chapters) {
                final chapterRef = semesterRef.collection('chapters').doc();
                batch.set(chapterRef, {
                  'name': chapter.name,
                  'backgroundImage': chapter.backgroundImage,
                  'number':
                      formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
                });

                // Initialize course number counter
                int courseNumber = 1;

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
                      'number': formatNumberAsString(courseNumber,
                          prefix: 'الوضعية '),
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    courseNumber++;
                  } else {
                    print(
                        'Failed to generate content for course: ${course.name}');
                  }
                }
                chapterNumber++;
              }
            }
          }
        }
      }

      // Commit the batch
      await batch.commit();

      print('Initialized level $levelName successfully');
    } catch (e) {
      print('Error initializing level $levelName: $e');
      throw e; // Re-throw the error for further handling
    }
  }

  // Function to initialize a specific year within a level
  Future<void> initializeSpecificYear(String levelName, String yearName) async {
    try {
      final level = educationSystem[levelName];
      if (level == null) {
        throw Exception('Level $levelName not found in education system');
      }

      final year = level.years[yearName];
      if (year == null) {
        throw Exception('Year $yearName not found in level $levelName');
      }

      final batch = _firestore.batch();

      // Create a reference for the education level
      final levelRef = _firestore.collection('education').doc(levelName);
      batch.set(levelRef, {'name': level.name});

      // Create a reference for the year
      final yearRef = levelRef.collection('years').doc(yearName);
      batch.set(yearRef, {
        'name': year.name,
        'departments': year.departments != null
            ? year.departments!
                .map((k, v) => MapEntry(k, v.map((s) => s.name).toList()))
            : null,
      });

      // Handle semesters if they exist
      if (year.semesters != null) {
        for (var semester in year.semesters!) {
          final semesterRef =
              yearRef.collection('semesters').doc(semester.name);
          batch.set(semesterRef, {'name': semester.name});

          // Initialize chapter number counter
          int chapterNumber = 1;

          // Handle chapters
          for (var chapter in semester.chapters) {
            final chapterRef = semesterRef.collection('chapters').doc();
            batch.set(chapterRef, {
              'name': chapter.name,
              'backgroundImage': chapter.backgroundImage,
              'number': formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
            });

            // Initialize course number counter
            int courseNumber = 1;

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
                  'number':
                      formatNumberAsString(courseNumber, prefix: 'الوضعية '),
                  'createdAt': FieldValue.serverTimestamp(),
                });
                courseNumber++;
              } else {
                print('Failed to generate content for course: ${course.name}');
              }
            }
            chapterNumber++;
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

            // Initialize chapter number counter
            int chapterNumber = 1;

            // Handle chapters
            for (var chapter in semester.chapters) {
              final chapterRef = semesterRef.collection('chapters').doc();
              batch.set(chapterRef, {
                'name': chapter.name,
                'backgroundImage': chapter.backgroundImage,
                'number':
                    formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
              });

              // Initialize course number counter
              int courseNumber = 1;

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
                    'number':
                        formatNumberAsString(courseNumber, prefix: 'الوضعية '),
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  courseNumber++;
                } else {
                  print(
                      'Failed to generate content for course: ${course.name}');
                }
              }
              chapterNumber++;
            }
          }
        }
      }

      // Commit the batch
      await batch.commit();

      print('Initialized year $yearName in level $levelName successfully');
    } catch (e) {
      print('Error initializing year $yearName in level $levelName: $e');
      throw e; // Re-throw the error for further handling
    }
  }

  Future<void> initializeSpecificDepartment(
    String levelName,
    String yearName,
    String departmentName,
  ) async {
    try {
      // Fetch the level from the education system
      final level = educationSystem[levelName];
      if (level == null) {
        throw Exception('Level $levelName not found in education system');
      }

      // Fetch the year from the level
      final year = level.years[yearName];
      if (year == null) {
        throw Exception('Year $yearName not found in level $levelName');
      }

      // Fetch the department from the year
      final department = year.departments?[departmentName];
      if (department == null) {
        throw Exception(
            'Department $departmentName not found in year $yearName');
      }

      // Use a batch to group all Firestore writes
      final batch = _firestore.batch();

      // Create a reference for the education level
      final levelRef = _firestore.collection('education').doc(levelName);
      batch.set(levelRef, {'name': level.name});

      // Create a reference for the year
      final yearRef = levelRef.collection('years').doc(yearName);
      batch.set(yearRef, {
        'name': year.name,
        'departments': year.departments != null
            ? year.departments!
                .map((k, v) => MapEntry(k, v.map((s) => s.name).toList()))
            : null,
      });

      // Create a reference for the department
      final departmentRef =
          yearRef.collection('departments').doc(departmentName);
      batch.set(departmentRef, {'name': departmentName});

      // Handle semesters within the department
      for (var semester in department) {
        final semesterRef =
            departmentRef.collection('semesters').doc(semester.name);
        batch.set(semesterRef, {'name': semester.name});

        // Initialize chapter number counter
        int chapterNumber = 1;

        // Handle chapters
        for (var chapter in semester.chapters) {
          final chapterRef = semesterRef.collection('chapters').doc();
          batch.set(chapterRef, {
            'name': chapter.name,
            'backgroundImage': chapter.backgroundImage,
            'number': formatNumberAsString(chapterNumber, prefix: 'الوحدة '),
          });

          // Initialize course number counter
          int courseNumber = 1;

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
                'number':
                    formatNumberAsString(courseNumber, prefix: 'الوضعية '),
                'createdAt': FieldValue.serverTimestamp(),
              });
              courseNumber++;
            } else {
              print('Failed to generate content for course: ${course.name}');
            }
          }
          chapterNumber++;
        }
      }

      // Commit the batch
      await batch.commit();

      print(
          'Initialized department $departmentName in year $yearName and level $levelName successfully');
    } catch (e) {
      print(
          'Error initializing department $departmentName in year $yearName and level $levelName: $e');
      throw e; // Re-throw the error for further handling
    }
  }
}
