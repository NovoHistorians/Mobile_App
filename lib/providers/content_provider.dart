import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

      if (cachedData != null && cachedData is List) {
        print('Returning cached data');

        // Validate and cast cached data
        final cachedChapters = (cachedData as List).map((json) {
          if (json is Map<String, dynamic>) {
            return Chapter.fromJson(json);
          } else {
            throw FormatException('Invalid cached data format');
          }
        }).toList();

        return cachedChapters;
      }

      // Fetch from Firestore if no cached data is found
      final yearRef = _firestore
          .collection('education')
          .doc(level)
          .collection('years')
          .doc(year);

      final yearDoc = await yearRef.get();

      if (!yearDoc.exists) {
        throw Exception('Year $year not found in level $level');
      }

      final yearData = yearDoc.data();
      final hasDepartments = yearData?['departments'] != false;

      List<Chapter> chapters = [];

      if (hasDepartments) {
        // Fetch chapters for each department
        final departmentsSnapshot =
            await yearRef.collection('departments').get();

        for (var departmentDoc in departmentsSnapshot.docs) {
          final departmentName = departmentDoc.id;
          final semestersSnapshot =
              await departmentDoc.reference.collection('semesters').get();

          for (var semesterDoc in semestersSnapshot.docs) {
            final semesterName = semesterDoc.id;
            final chaptersSnapshot =
                await semesterDoc.reference.collection('chapters').get();

            final departmentChapters = await _processChapters(chaptersSnapshot);
            chapters.addAll(departmentChapters);
          }
        }
      } else {
        // Fetch chapters directly from the year's semesters
        final semestersSnapshot = await yearRef.collection('semesters').get();

        for (var semesterDoc in semestersSnapshot.docs) {
          final semesterName = semesterDoc.id;
          final chaptersSnapshot =
              await semesterDoc.reference.collection('chapters').get();

          final semesterChapters = await _processChapters(chaptersSnapshot);
          chapters.addAll(semesterChapters);
        }
      }

      // Remove duplicate chapters
      final uniqueChapters = chapters.toSet().toList();

      // Cache the data
      await box.put(cacheKey, uniqueChapters.map((c) => c.toJson()).toList());
      print('Data cached successfully');

      return uniqueChapters;
    } catch (e) {
      print('Error fetching chapters: $e');
      throw e;
    }
  }

  Future<List<Chapter>> getChapters_with(String level, String year) async {
    try {
      print('Fetching chapters for level: $level, year: $year');

      // Check cache
      final box = await Hive.openBox(_boxName);
      final cacheKey = 'chapters_${level}_$year';
      final cachedData = box.get(cacheKey);

      if (cachedData != null && cachedData is List) {
        print('Returning cached data');

        // Validate and cast cached data
        final cachedChapters = (cachedData as List).map((json) {
          if (json is Map<String, dynamic>) {
            return Chapter.fromJson(json);
          } else {
            throw FormatException('Invalid cached data format');
          }
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
              title: data['name'] ?? '',
              content: data['content'] ?? '',
              quiz: Quiz(
                id: courseDoc.id,
                title: 'Quiz for ${data['name']}',
                questions: [],
                score: 0,
              ),
            );
          }).toList();

          return Chapter(
            id: doc.id,
            number: doc.data()['number'] ?? '',
            title: doc.data()['name'] ?? '',
            courses: courses,
            backgroundImage: doc.data()['backgroundImage'] ?? '',
          );
        }),
      );

      // Cache the data
      await box.put(cacheKey, chapters.map((c) => c.toJson()).toList());
      print('Data cached successfully');

      return chapters;
    } catch (e) {
      print('Error fetching chapters: $e');
      throw e;
    }
  }

  Future<List<Chapter>> _processChapters(QuerySnapshot chaptersSnapshot) async {
    return await Future.wait(
      chaptersSnapshot.docs.map((doc) async {
        print('Processing chapter: ${doc.id}');
        final data =
            doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        final coursesSnapshot = await doc.reference.collection('courses').get();

        final courses = coursesSnapshot.docs.map((courseDoc) {
          final courseData = courseDoc.data()
              as Map<String, dynamic>; // Cast to Map<String, dynamic>
          print('Processing course: ${courseData['name']}');

          return Course(
            id: courseDoc.id,
            number: courseData['number'] ?? '',
            title: courseData['name'] ?? '',
            content: courseData['content'] ?? '',
            quiz: Quiz(
              id: courseDoc.id,
              title: 'Quiz for ${courseData['name']}',
              questions: [],
              score: 0,
            ),
          );
        }).toList();

        return Chapter(
          id: doc.id,
          number: data['number'] ?? '', // Access after casting
          title: data['name'] ?? '', // Access after casting
          courses: courses,
          backgroundImage:
              data['backgroundImage'] ?? '', // Access after casting
        );
      }),
    );
  }
}
