// Chat provider with enhanced functionality
import 'package:flutter/material.dart';

import '../data/qaservices.dart';
import '../models/flashcard_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  List<String> _suggestions = [];

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  List<String> get suggestions => _suggestions;

  void updateSuggestions(String query) {
    _suggestions = QAService.getSuggestions(query);
    notifyListeners();
  }

  void addMessage(String text, bool isUser) {
    _messages.add(
      ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    if (isUser) {
      _isTyping = true;
      notifyListeners();

      // Simulate network delay
      Future.delayed(Duration(seconds: 1), () {
        _isTyping = false;
        final response = QAService.getAnswer(text);
        addMessage(response!, false);
      });
    }
  }

  void clearSuggestions() {
    _suggestions = [];
    notifyListeners();
  }
}
