import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/level_years.dart';

class FirebaseInitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeEducationContent() async {
    try {
      final batch = _firestore.batch();

      for (var levelEntry in educationSystem.entries) {
        final levelRef = _firestore.collection('education').doc(levelEntry.key);
        batch.set(levelRef, {'name': levelEntry.value.name});

        for (var yearEntry in levelEntry.value.years.entries) {
          final yearRef = levelRef.collection('years').doc(yearEntry.key);
          batch.set(yearRef, {
            'name': yearEntry.value.name,
            'departments': yearEntry.value.departments,
          });

          for (var semester in yearEntry.value.semesters) {
            final semesterRef =
                yearRef.collection('semesters').doc(semester.name);
            batch.set(semesterRef, {'name': semester.name});

            for (var chapter in semester.chapters) {
              final chapterRef = semesterRef.collection('chapters').doc();
              batch.set(chapterRef, {
                'number': chapter.name,
                'title': chapter.name,
                'backgroundImage': chapter.backgroundImage,
              });

              for (var course in chapter.courses) {
                final courseRef = chapterRef.collection('courses').doc();
                batch.set(courseRef, {
                  'number': '1',
                  'title': course.name,
                  'content': course.content,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              }
            }
          }
        }
      }

      await batch.commit();
      print('Education content initialized successfully');
    } catch (e) {
      print('Error initializing education content: $e');
      throw e;
    }
  }

  Future<bool> checkInitializationStatus() async {
    try {
      final snapshot = await _firestore.collection('education').get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking initialization status: $e');
      return false;
    }
  }
}
