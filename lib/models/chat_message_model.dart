import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp,
      'type': type == MessageType.text ? 'text' : 'suggestion',
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      isUser: json['isUser'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      type: json['type'] == 'text' ? MessageType.text : MessageType.suggestion,
    );
  }
}

enum MessageType { text, suggestion }
