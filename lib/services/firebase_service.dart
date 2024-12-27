import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserData(Map<String, dynamic> data) async {
    await _firestore.collection('users').add(data);
  }

  Future<List<Map<String, dynamic>>> getChapters() async {
    final snapshot = await _firestore.collection('chapters').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
} 