import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/quiz_model.dart';
import '../services/quiz_generator_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizGeneratorService _quizGenerator;
  final SharedPreferences _prefs;

  QuizProvider(this._quizGenerator, this._prefs);

  Future<Quiz> getQuizForCourse(
    String courseId,
    String content,
    String level,
    String year,
  ) async {
    try {
      developer.log('Starting getQuizForCourse for courseId: $courseId');

      final quizKey = 'quiz_${courseId}_${level}_$year';
      // Check if quiz exists in SharedPreferences
      final quizJson = _prefs.getString(quizKey);

      if (quizJson != null) {
        developer.log('Found existing quiz in SharedPreferences');
        final quiz = Quiz.fromJson(jsonDecode(quizJson));
        developer.log(
            'Quiz retrieved from cache: ${quiz.questions.length} questions');
        return quiz;
      }

      developer.log('No existing quiz found, generating new quiz');
      developer.log('Content length: ${content.length}');
      developer.log('Level: $level');
      developer.log('Year: $year');

      // Generate new quiz
      final quiz = await _quizGenerator.generateQuiz(
        content,
        level,
        year,
      );

      developer.log(
          'Quiz generated successfully with ${quiz.questions.length} questions');

      // Save to SharedPreferences
      await _prefs.setString(quizKey, jsonEncode(quiz.toJson()));
      developer.log('Quiz saved to SharedPreferences: ${quiz.toJson()}');

      return quiz;
    } catch (e, stackTrace) {
      developer.log('Error in getQuizForCourse: $e');
      developer.log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> removeQuiz(String courseId, String level, String year) async {
    final quizKey = 'quiz_${courseId}_${level}_$year';
    await _prefs.remove(quizKey);
    developer.log('Removed quiz with key: $quizKey');
  }

  Future<void> clearAllQuizzes() async {
    final keys = _prefs.getKeys();
    final quizKeys = keys.where((key) => key.startsWith('quiz_'));
    for (final key in quizKeys) {
      await _prefs.remove(key);
    }
    developer.log('Cleared all quizzes');
    notifyListeners();
  }
}
