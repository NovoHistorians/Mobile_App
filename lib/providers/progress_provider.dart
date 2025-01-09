// providers/progress_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/course_model.dart';
import '../models/user_model.dart';
import 'study_tracker.dart';

class ProgressProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _boxName = 'progressBox';

  Future<int> completeCourse({
    required String userId,
    required Course course,
    required double completion,
    required int quizScore,
    required UserModel user,
    required int stars,
  }) async {
    try {
      // Prepare the progress data
      final progressData = {
        'isCompleted': true,
        'completion': completion,
        'quizScore': quizScore,
        'lastUpdated': DateTime.now().toIso8601String(),
        'stars': stars,
      };

      // Update local course state
      course.isCompleted = true;
      course.quiz.score = quizScore;

      // Update Firestore: Save progress under the user's progress collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(course.id) // Use course ID as the document ID
          .set(progressData, SetOptions(merge: true));

      // Update local storage (Hive)
      final box = await Hive.openBox(_boxName);
      await box.put('progress_${userId}_${course.id}', progressData);

      // Record study session
      await StudyTracker.recordStudySession(userId);
      final streak = await StudyTracker.getStudyStreak(userId);

      // Update user model
      user.updateProgress(course.id, completion);

      //final totalStars = await calculateTotalStars(userId);
      //user.updateTotalStars(totalStars);

      notifyListeners();

      // Return the study streak for UI updates if needed
      return streak;
    } catch (e) {
      print('Error completing course: $e');
      throw e;
    }
  }

  Future<void> resetProgress(
      String userId, String courseId, UserModel user) async {
    try {
      // Get the current progress to find out how many stars to subtract
      final currentProgress = await getUserProgress(userId, courseId);
      final previousStars = currentProgress['stars'] as int? ?? 0;

      // Subtract the stars from user's total
      final newTotalStars = user.totalNumberOfStars - previousStars;
      user.updateTotalStars(newTotalStars);

      // Update user's total stars in Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'totalStars': newTotalStars});
      // Reset progress in Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(courseId)
          .set({
        'completion': 0,
        'isCompleted': false,
        'quizScore': 0,
        'lastUpdated': DateTime.now().toIso8601String(),
        'stars': 0,
      }, SetOptions(merge: true));

      // Reset progress in local storage (Hive)
      final box = await Hive.openBox(_boxName);
      await box.put('progress_${userId}_$courseId', {
        'isCompleted': false,
        'quizScore': 0,
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      notifyListeners();
    } catch (e) {
      print('Error resetting progress: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> getProgress(
      String userId, String courseId) async {
    try {
      // Check local storage first
      final box = await Hive.openBox(_boxName);
      final localProgress = box.get('progress_${userId}_$courseId');

      if (localProgress != null) {
        return Map<String, dynamic>.from(localProgress);
      }

      // If not found locally, fetch from Firestore
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(courseId)
          .get();

      if (doc.exists) {
        final progress = doc.data()!;
        // Cache the progress locally
        await box.put('progress_${userId}_$courseId', progress);
        return progress;
      }

      return {};
    } catch (e) {
      print('Error getting progress: $e');
      return {};
    }
  }

  Future<void> syncOfflineProgress(String userId) async {
    try {
      final box = await Hive.openBox(_boxName);
      final keys =
          box.keys.where((k) => k.toString().startsWith('progress_$userId'));

      for (final key in keys) {
        final progress = box.get(key);
        final courseId = key.toString().split('_').last;

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('progress')
            .doc(courseId)
            .set(progress, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error syncing offline progress: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> getUserProgress(
      String userId, String courseId) async {
    try {
      // Check local storage first
      final box = await Hive.openBox(_boxName);
      final localProgress = box.get('progress_${userId}_$courseId');

      if (localProgress != null) {
        return Map<String, dynamic>.from(localProgress);
      }

      // If not found locally, fetch from Firestore
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(courseId)
          .get();

      if (doc.exists) {
        final progress = doc.data()!;
        // Cache the progress locally
        await box.put('progress_${userId}_$courseId', progress);
        return progress;
      }

      return {};
    } catch (e) {
      print('Error getting progress: $e');
      return {};
    }
  }
}
