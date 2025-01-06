import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StudyNotificationService _notificationService =
      StudyNotificationService();
  UserModel? _user;

  UserModel? get user => _user;

  // Load user data from Firestore
  Future<void> loadUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        print('User data from Firestore: $userData');
        print('User data type: ${userData.runtimeType}');

        // Explicitly cast the data to Map<String, dynamic>
        final castedData = userData as Map<String, dynamic>;
        _user = UserModel.fromJson(castedData);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Sign up a new user
  Future<void> signUp(String email, String password, String name, String level,
      String year, String? department) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        level: level,
        year: year,
        department: department,
        avatar: 'assets/avatars/default.png',
        chapters: [],
        progress: {},
        studySessions: [],
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

      // Create progress subcollection
      await _firestore
          .collection('users')
          .doc(user.id)
          .collection('progress')
          .doc('overview')
          .set({
        'lastAccessed': DateTime.now(),
        'completedCourses': 0,
        'totalQuizScore': 0,
        'studyStreak': 0,
      });

      _user = user;
      notifyListeners();

      // Initialize local storage
      await _initializeLocalStorage(user);
    } catch (e) {
      print('Error during sign up: $e');
      throw e;
    }
  }

  Future<void> _initializeLocalStorage(UserModel user) async {
    final box = await Hive.openBox('userBox');
    // Ensure the data is stored as Map<String, dynamic>
    await box.put('userData', user.toJson());

    // Cache chapters for offline access
    final chaptersBox = await Hive.openBox('chaptersBox');
    await chaptersBox.put('userChapters', user.chapters);
  }

  Future<void> syncOfflineData() async {
    if (_user == null) return;

    final box = await Hive.openBox('userBox');
    final offlineData = box.get('userData');
    print('Offline data from Hive: $offlineData');
    print('Offline data type: ${offlineData.runtimeType}');

    if (offlineData != null) {
      // Explicitly cast the data to Map<String, dynamic>
      final userData =
          Map<String, dynamic>.from(offlineData as Map<dynamic, dynamic>);
      await _firestore.collection('users').doc(_user!.id).update(userData);
    }
  }

  // Log in an existing user
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await loadUserData(userCredential.user!.uid);
    } catch (e) {
      print('Error during login: $e');
      throw e;
    }
  }

  // Log out the user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
      throw e;
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  Future<void> saveUserProgress(UserModel user) async {
    final progressBox = Hive.box<UserModel>('progress');
    await progressBox.put(user.id, user);
  }

  Future<UserModel?> getUserProgress(String userId) async {
    final progressBox = Hive.box<UserModel>('progress');
    return progressBox.get(userId);
  }

  Future<void> updateStudyProgress(String courseId, double completion) async {
    if (_user == null) return;

    try {
      // Update local state
      _user!.updateProgress(courseId, completion);

      // Update Firestore
      await _firestore.collection('users').doc(_user!.id).update({
        'progress.$courseId': completion,
      });

      // Update local storage
      final box = await Hive.openBox('userBox');
      await box.put('userData', _user!.toJson());

      notifyListeners();
    } catch (e) {
      print('Error updating progress: $e');
      throw e;
    }
  }

  Future<void> initializeUser() async {
    try {
      // Check if user is already logged in
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Load user data from Firestore
        await loadUserData(currentUser.uid);

        // Sync any offline data
        await syncOfflineData();
      }
    } catch (e) {
      print('Error initializing user: $e');
      _user = null;
    }
    notifyListeners();
  }

  // Schedule user notifications
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
