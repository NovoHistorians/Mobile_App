import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class UserProvider with ChangeNotifier {
  final StudyNotificationService _notificationService =
      StudyNotificationService();
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    _notificationService.scheduleDailyStudyReminder(user);
    notifyListeners();
  }

  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners(); // This will trigger a rebuild of all listening widgets
  }
}
