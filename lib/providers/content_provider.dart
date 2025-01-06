// providers/content_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/chapter_model.dart';
import '../models/course_model.dart';
import '../models/quiz_model.dart';

class ContentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _boxName = 'contentBox';

  Future<List<Chapter>> getChapters(String level, String year) async {
    try {
      print('Fetching chapters for level: $level, year: $year');

      // Check cache
      final box = await Hive.openBox(_boxName);
      final cacheKey = 'chapters_${level}_$year';
      final cachedData = box.get(cacheKey);

      if (cachedData != null) {
        print('Returning cached data');

        // Explicitly cast the cached data to List<Map<String, dynamic>>
        final cachedChapters = (cachedData as List).map((json) {
          return Chapter.fromJson(
              Map<String, dynamic>.from(json as Map<dynamic, dynamic>));
        }).toList();

        return cachedChapters;
      }

      // Fetch from Firestore if no cached data is found
      final chaptersRef = _firestore
          .collection('education')
          .doc(level)
          .collection('years')
          .doc(year)
          .collection('semesters')
          .doc('الفصل الأول') // Add semester level
          .collection('chapters');

      final snapshot = await chaptersRef.get();
      print('Found ${snapshot.docs.length} chapters');

      final chapters = await Future.wait(
        snapshot.docs.map((doc) async {
          print('Processing chapter: ${doc.id}');
          final coursesSnapshot =
              await doc.reference.collection('courses').get();

          final courses = coursesSnapshot.docs.map((courseDoc) {
            final data = courseDoc.data();
            print('Processing course: ${data['title']}');

            return Course(
              id: courseDoc.id,
              number: data['number'] ?? '',
              title: data['title'] ?? '',
              content: data['content'] ?? '',
              quiz: Quiz(
                id: courseDoc.id,
                title: 'Quiz for ${data['title']}',
                questions: [],
                score: 0,
              ),
            );
          }).toList();

          return Chapter(
            id: doc.id,
            number: doc.data()['number'] ?? '',
            title: doc.data()['title'] ?? '',
            courses: courses,
            backgroundImage: doc.data()['backgroundImage'] ?? '',
          );
        }),
      );

      // Cache the data
      await box.put(cacheKey, chapters.map((c) => c.toJson()).toList());

      return chapters;
    } catch (e) {
      print('Error fetching chapters: $e');
      throw e;
    }
  }
}
