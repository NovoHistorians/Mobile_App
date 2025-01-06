import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chapter_model.dart';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Chapter> _chapters = [];

  List<Chapter> get chapters => _chapters;

  Future<void> loadChapters(String level, String year) async {
    try {
      QuerySnapshot chapterSnapshot = await _firestore
          .collection('chapters')
          .where('level', isEqualTo: level)
          .where('year', isEqualTo: year)
          .get();
      _chapters = chapterSnapshot.docs
          .map((doc) => Chapter.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading chapters: $e');
    }
  }
}
