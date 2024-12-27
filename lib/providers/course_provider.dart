import 'package:flutter/material.dart';

import '../models/chapter_model.dart';

class CourseProvider with ChangeNotifier {
  List<ChapterCard> _chapters = [];

  List<ChapterCard> get chapters => _chapters;

  void setChapters(List<ChapterCard> chapters) {
    _chapters = chapters;
    notifyListeners();
  }
}
