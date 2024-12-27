import 'package:flutter/material.dart';
import 'chapter_model.dart';

class UserModel with ChangeNotifier {
  String _name;
  String _level;
  String _year;
  String _avatar;
  List<Chapter> _chapters;

  UserModel({
    required String name,
    required String level,
    required String year,
    required String avatar,
    required List<Chapter> chapters,
  })  : _name = name,
        _level = level,
        _year = year,
        _avatar = avatar,
        _chapters = chapters;

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get level => _level;
  set level(String value) {
    _level = value;
    notifyListeners();
  }

  String get year => _year;
  set year(String value) {
    _year = value;
    notifyListeners();
  }

  String get avatar => _avatar;
  set avatar(String value) {
    _avatar = value;
    notifyListeners();
  }

  List<Chapter> get chapters => _chapters;
  set chapters(List<Chapter> value) {
    _chapters = value;
    notifyListeners();
  }
}
