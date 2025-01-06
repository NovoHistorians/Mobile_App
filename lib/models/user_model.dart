import 'package:flutter/material.dart';
import 'chapter_model.dart';

class UserModel with ChangeNotifier {
  String _id;
  String _email; // Added email
  String _name;
  String _level;
  String _year;
  String _department; // Added department
  String _avatar;
  List<Chapter> _chapters;
  Map<String, dynamic> _progress; // Added progress tracking
  List<DateTime> _studySessions;

  UserModel({
    required String id,
    required String email,
    required String name,
    required String level,
    required String year,
    String? department,
    required String avatar,
    required List<Chapter> chapters,
    Map<String, dynamic>? progress,
    List<DateTime>? studySessions,
  })  : _id = id,
        _email = email,
        _name = name,
        _level = level,
        _year = year,
        _department = department ?? '',
        _avatar = avatar,
        _chapters = chapters,
        _progress = progress ?? {},
        _studySessions = studySessions ?? [];

  String get id => _id;
  String get name => _name;
  String get level => _level;
  String get year => _year;
  String get avatar => _avatar;
  List<Chapter> get chapters => _chapters;
  String get email => _email;
  String get department => _department;
  Map<String, dynamic> get progress => _progress;
  List<DateTime> get studySessions => _studySessions;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set level(String value) {
    _level = value;
    notifyListeners();
  }

  set year(String value) {
    _year = value;
    notifyListeners();
  }

  set department(String value) {
    _department = value;
    notifyListeners();
  }

  set avatar(String value) {
    _avatar = value;
    notifyListeners();
  }

  set chapters(List<Chapter> value) {
    _chapters = value;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'email': _email,
      'name': _name,
      'level': _level,
      'year': _year,
      'department': _department,
      'avatar': _avatar,
      'chapters': _chapters.map((chapter) => chapter.toJson()).toList(),
      'progress': _progress,
      'studySessions':
          studySessions.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      level: json['level'],
      year: json['year'],
      department: json['department'],
      avatar: json['avatar'],
      chapters: (json['chapters'] as List?)
              ?.map((chapter) => Chapter.fromJson(chapter))
              .toList() ??
          [],
      progress: json['progress'] as Map<String, dynamic>? ?? {},
      studySessions: (json['studySessions'] as List?)
              ?.map((date) => DateTime.parse(date))
              .toList() ??
          [],
    );
  }

  void updateProgress(String courseId, double completion) {
    _progress[courseId] = completion;
    notifyListeners();
  }

  void addStudySession(DateTime session) {
    _studySessions.add(session);
    notifyListeners();
  }
}
