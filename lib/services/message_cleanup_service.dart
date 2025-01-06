import 'package:cloud_firestore/cloud_firestore.dart';

class MessageCleanupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cleanupOldMessages() async {
    try {
      final fiveDaysAgo = DateTime.now().subtract(Duration(days: 5));
      
      final usersSnapshot = await _firestore.collection('users').get();
      
      for (var userDoc in usersSnapshot.docs) {
        final querySnapshot = await userDoc.reference
            .collection('messages')
            .where('timestamp', isLessThan: fiveDaysAgo)
            .get();

        final batch = _firestore.batch();
        querySnapshot.docs.forEach((doc) {
          batch.delete(doc.reference);
        });
        
        await batch.commit();
      }
    } catch (e) {
      print('Error cleaning up messages: $e');
    }
  }
}