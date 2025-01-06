import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class StudyTracker {
  static Future<void> recordStudySession(String userId) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final session = DateTime.now();

      await userRef.update({
        'studySessions': FieldValue.arrayUnion([session.toIso8601String()]),
      });

      // Update local storage
      final box = await Hive.openBox('userBox');
      final userData = box.get('userData');
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        user.addStudySession(session);
        await box.put('userData', user.toJson());
      }
    } catch (e) {
      print('Error recording study session: $e');
      throw e;
    }
  }

  static Future<int> getStudyStreak(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final studySessions = (userDoc.data()?['studySessions'] as List? ?? [])
          .map((date) => DateTime.parse(date))
          .toList();

      if (studySessions.isEmpty) return 0;

      studySessions.sort();
      final now = DateTime.now();
      int streak = 1;

      for (int i = studySessions.length - 2; i >= 0; i--) {
        final difference =
            studySessions[i + 1].difference(studySessions[i]).inDays;
        if (difference == 1) {
          streak++;
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      print('Error calculating study streak: $e');
      return 0;
    }
  }
}
