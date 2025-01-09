import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String level,
    required String year,
    String? department,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
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

      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('Error during signup: $e');
      throw e;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      _currentUser = UserModel.fromJson(userDoc.data()!);
      notifyListeners();
    } catch (e) {
      print('Error during signin: $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error during signout: $e');
      throw e;
    }
  }
}
