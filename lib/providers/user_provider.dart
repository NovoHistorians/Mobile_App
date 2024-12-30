import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class UserProvider with ChangeNotifier {
  final StudyNotificationService _notificationService =
      StudyNotificationService();
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> setUser(UserModel user) async {
    _user = user;
    await _scheduleUserNotifications();
    notifyListeners();
  }

  Future<void> updateUser(UserModel updatedUser) async {
    _user = updatedUser;
    await _scheduleUserNotifications();
    notifyListeners();
  }

  Future<void> _scheduleUserNotifications() async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final studyRemindersEnabled = prefs.getBool('study_reminders') ?? true;

    if (studyRemindersEnabled) {
      // Schedule morning reminder
      final morningHour = prefs.getInt('morning_reminder_hour') ?? 10;
      final morningMinute = prefs.getInt('morning_reminder_minute') ?? 0;
      await _notificationService.scheduleDailyStudyReminder(
        TimeOfDay(hour: morningHour, minute: morningMinute),
        type: 'morning',
      );

      // Schedule evening reminder
      final eveningHour = prefs.getInt('evening_reminder_hour') ?? 18;
      final eveningMinute = prefs.getInt('evening_reminder_minute') ?? 0;
      await _notificationService.scheduleDailyStudyReminder(
        TimeOfDay(hour: eveningHour, minute: eveningMinute),
        type: 'evening',
      );
    }
  }
}
