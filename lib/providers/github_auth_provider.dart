import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class gitHubAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGitHub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      githubProvider.addScope('repo');
      githubProvider.setCustomParameters({
        'allow_signup': 'false',
      });

      final UserCredential authResult =
          await _auth.signInWithProvider(githubProvider);
      final User? user = authResult.user;

      return user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOutFromGitHub() async {
    await _auth.signOut();
  }
}
