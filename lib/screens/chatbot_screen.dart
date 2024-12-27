import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/flashcard_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/custom_scaffold.dart';

class ChatbotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: ChatbotScreenContent(),
    );
  }
}

class ChatbotScreenContent extends StatefulWidget {
  @override
  _ChatbotScreenContentState createState() => _ChatbotScreenContentState();
}

class _ChatbotScreenContentState extends State<ChatbotScreenContent> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print('TextField gained focus');
      } else {
        print('TextField lost focus');
      }
    });
  }

  void _onTextChanged() {
    final provider = Provider.of<ChatProvider>(context, listen: false);

    // Check if the text contains Arabic characters
    bool containsArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(_textController.text);

    if (!containsArabic) {
      provider.updateSuggestions(_textController.text);
    } else {
      // Clear suggestions for Arabic to avoid issues
      provider.clearSuggestions();
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    // Clear text and add the message
    _textController.clear();
    Provider.of<ChatProvider>(context, listen: false)
      ..clearSuggestions()
      ..addMessage(text, true);

    // Avoid immediately requesting focus; delay slightly to prevent flickering
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    // Scroll to bottom after a short delay
    Future.delayed(Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "مساعدك في التاريخ",
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFF5F5F5),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: chatProvider.messages.length +
                        (chatProvider.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatProvider.messages.length &&
                          chatProvider.isTyping) {
                        return _buildTypingIndicator();
                      }

                      final message = chatProvider.messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return Column(
                children: [
                  if (chatProvider.suggestions.isNotEmpty)
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemCount: chatProvider.suggestions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ActionChip(
                              label: Text(chatProvider.suggestions[index]),
                              onPressed: () {
                                _handleSubmit(chatProvider.suggestions[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  _buildInputField(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 8),
            child: Image.asset(
              "assets/images/chat.png",
              height: 50,
              width: 50,
            ),
          ),
          Container(
            width: 60,
            height: 30,
            child: Lottie.network(
              'https://assets5.lottiefiles.com/packages/lf20_kyvxw1w8.json',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Image.asset(
              "assets/images/chat.png",
              height: 50,
              width: 50,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? Color(0xFF7A6C5D) : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: !message.isUser
                      ? Radius.circular(20)
                      : Radius.circular(0),
                  topLeft: !message.isUser
                      ? Radius.circular(0)
                      : Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                textDirection: TextDirection
                    .rtl, // Explicitly set text direction for Arabic
                decoration: InputDecoration(
                  hintText: 'اكتب سؤالك هنا...',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: _handleSubmit,
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              child: Image.asset(
                "assets/images/send.png",
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
              onPressed: () => _handleSubmit(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
