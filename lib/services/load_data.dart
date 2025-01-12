import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getEducationLevels() async {
    try {
      final snapshot = await _firestore.collection('education').get();
      print('Firestore Documents: ${snapshot.docs}'); // Debug
      Map<String, dynamic> levels = {};

      for (var doc in snapshot.docs) {
        levels[doc.id] = doc.data();
      }
      return levels;
    } catch (e) {
      print('Error fetching education levels: $e');
      throw e;
    }
  }

  Future<List<String>> getYearsForLevel(String level) async {
    try {
      final snapshot = await _firestore
          .collection('education')
          .doc(level)
          .collection('years')
          .get();

      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      print('Error fetching years: $e');
      throw e;
    }
  }

  Future<List<String>> getDepartments(String level, String year) async {
    try {
      // Get the year document
      final yearDoc = await _firestore
          .collection('education')
          .doc(level)
          .collection('years')
          .doc(year)
          .get();

      if (!yearDoc.exists) {
        print('Year document does not exist');
        return [];
      }

      // Get all department documents from the departments subcollection
      final departmentsSnapshot = await _firestore
          .collection('education')
          .doc(level)
          .collection('years')
          .doc(year)
          .collection('departments')
          .get();

      return departmentsSnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching departments: $e');
      throw e;
    }
  }
}
