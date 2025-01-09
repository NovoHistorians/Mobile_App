import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;

  UserModel? get user => _user;

  // Load user data from Firestore
  Future<void> loadUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        print('User data from Firestore: $userData');

        // Explicitly cast the data to Map<String, dynamic>
        final castedData =
            Map<String, dynamic>.from(userData as Map<dynamic, dynamic>);
        _user = UserModel.fromJson(castedData);

        // Cache the user data locally
        final box = await Hive.openBox('userBox');
        await box.put('userData', _user!.toJson());

        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
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

  Future<void> syncOfflineData() async {
    if (_user == null) return;

    final box = await Hive.openBox('userBox');
    final offlineData = box.get('userData');
    print('Offline data from Hive: $offlineData');

    if (offlineData != null && offlineData is Map<String, dynamic>) {
      await _firestore.collection('users').doc(_user!.id).update(offlineData);
    } else {
      print('Invalid offline data format');
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
        totalStars: 0,
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

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
        'progress.$courseId': {
          'isCompleted': true,
          'completion': completion,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
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

  Future<void> updateTotalStars(int newStars) async {
    if (_user == null) return;

    try {
      // Update local state
      _user!.updateTotalStars(newStars);

      // Update Firestore
      await _firestore.collection('users').doc(_user!.id).update({
        'totalStars': newStars,
      });

      // Update local storage
      final box = await Hive.openBox('userBox');
      await box.put('userData', _user!.toJson());

      notifyListeners();
    } catch (e) {
      print('Error updating total stars: $e');
      throw e;
    }
  }
}
