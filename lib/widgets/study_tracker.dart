// study_tracker.dart

import 'package:shared_preferences/shared_preferences.dart';

class StudyTracker {
  static const String _lastStudyDateKey = 'last_study_date';
  static const String _streakCountKey = 'streak_count';

  static Future<void> recordStudySession() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().split(' ')[0];
    final lastStudyDate = prefs.getString(_lastStudyDateKey);

    if (lastStudyDate != null) {
      final lastDate = DateTime.parse(lastStudyDate);
      final difference = DateTime.parse(today).difference(lastDate).inDays;

      if (difference == 1) {
        // Consecutive day
        final currentStreak = prefs.getInt(_streakCountKey) ?? 0;
        await prefs.setInt(_streakCountKey, currentStreak + 1);
      } else if (difference > 1) {
        // Streak broken
        await prefs.setInt(_streakCountKey, 1);
      }
    } else {
      // First study session
      await prefs.setInt(_streakCountKey, 1);
    }

    await prefs.setString(_lastStudyDateKey, today);
  }

  static Future<int> getStudyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  static Future<bool> checkInactivity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStudyDate = prefs.getString(_lastStudyDateKey);

    if (lastStudyDate != null) {
      final lastDate = DateTime.parse(lastStudyDate);
      final difference = DateTime.now().difference(lastDate).inDays;
      return difference > 2; // Consider inactive after 2 days
    }
    return false;
  }
}
