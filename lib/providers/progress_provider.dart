// providers/progress_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProgressProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _boxName = 'progressBox';

  Future<void> trackProgress({
    required String userId,
    required String courseId,
    required double completion,
    required int quizScore,
  }) async {
    try {
      final progress = {
        'completion': completion,
        'quizScore': quizScore,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // Save to local storage first
      final box = await Hive.openBox(_boxName);
      await box.put('progress_${userId}_$courseId', progress);

      // Then update Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(courseId)
          .set(progress, SetOptions(merge: true));

      notifyListeners();
    } catch (e) {
      print('Error tracking progress: $e');
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
}
