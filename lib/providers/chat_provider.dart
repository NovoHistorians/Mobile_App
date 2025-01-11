import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';
import '../services/openAi_service.dart';
import '../services/message_cleanup_service.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final OpenAIService _openAIService;
  final MessageCleanupService _cleanupService = MessageCleanupService();
  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  ChatProvider(this._openAIService);

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> addMessage(String userId, String text, bool isUser) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      );

      // Save message to Firestore with TTL
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .doc(message.id)
          .set({
        ...message.toJson(),
        'ttl': FieldValue.serverTimestamp(),
      });

      _messages.insert(0, message);
      notifyListeners();

      if (isUser) {
        _isTyping = true;
        notifyListeners();

        try {
          // Fetch the user's level from Firestore
          final userDoc =
              await _firestore.collection('users').doc(userId).get();
          final level = userDoc.data()?['year'] as String?;

          if (level == null || level.isEmpty) {
            throw Exception('User year is missing or invalid.');
          }

          // Get AI response using the retrieved level
          final response = await _openAIService.getResponse(text, level);

          _isTyping = false;
          await addMessage(userId, response, false);
        } catch (e) {
          _isTyping = false;
          await addMessage(
            userId,
            'عذراً، حدث خطأ في الاتصال. حاول مرة أخرى.',
            false,
          );
        }
      }
    } catch (e) {
      print('Error adding message: $e');
    }
  }

  Future<List<ChatMessage>> loadMoreMessages(
    String userId, {
    required DateTime lastMessageTimestamp,
    required int limit,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .startAfter([lastMessageTimestamp])
          .limit(limit)
          .get();

      final messages =
          snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList();

      _messages.addAll(messages);
      notifyListeners();
      return messages;
    } catch (e) {
      print('Error loading more messages: $e');
      return [];
    }
  }

  Future<void> loadMessages(String userId, {int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      _messages =
          snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      print('Error loading messages: $e');
      throw e;
    }
  }
}
