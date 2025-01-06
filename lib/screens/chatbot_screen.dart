import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';
import '../providers/chat_provider.dart';
import '../providers/user_provider.dart';
import '../services/openAi_service.dart';
import '../widgets/custom_scaffold.dart';

class ChatbotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final openAIService = OpenAIService(
        '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');
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(openAIService),
      child: ChatbotScreenContent(),
    );
  }
}

class ChatbotScreenContent extends StatefulWidget {
  @override
  _ChatbotScreenContentState createState() => _ChatbotScreenContentState();
}

class _ChatbotScreenContentState extends State<ChatbotScreenContent> {
  static const int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _scrollController.addListener(_onScroll);
    _loadInitialMessages();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      print('TextField gained focus');
    } else {
      print('TextField lost focus');
    }
  }

  Future<void> _loadMessages() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      await Provider.of<ChatProvider>(context, listen: false)
          .loadMessages(user.id);
    }
  }

  Future<void> _loadInitialMessages() async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        await Provider.of<ChatProvider>(context, listen: false)
            .loadMessages(user.id, limit: _pageSize);
      }
    } catch (e) {
      _showErrorSnackBar();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (!_isLoadingMore && _hasMore) {
      setState(() => _isLoadingMore = true);
      try {
        final user = Provider.of<UserProvider>(context, listen: false).user;
        if (user != null) {
          final chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          final lastMessage = chatProvider.messages.last;
          final moreMessages = await chatProvider.loadMoreMessages(
            user.id,
            lastMessageTimestamp: lastMessage.timestamp,
            limit: _pageSize,
          );
          _hasMore = moreMessages.length >= _pageSize;
        }
      } catch (e) {
        _showErrorSnackBar();
      } finally {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreMessages();
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'حدث خطأ. الرجاء المحاولة مرة أخرى',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    String sanitizedText = text.trim().replaceAll(RegExp(r'\n\s*\n'), '\n');
    _textController.clear();

    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        await Provider.of<ChatProvider>(context, listen: false)
            .addMessage(user.id, sanitizedText, true);
      }
      _scrollToBottom();
    } catch (e) {
      _showErrorSnackBar();
    }

    if (mounted) _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "مساعدك في التاريخ",
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFEBEBD3),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.all(16),
                    itemCount: chatProvider.messages.length +
                        (chatProvider.isTyping ? 1 : 0) +
                        (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && _isLoadingMore) {
                        return _buildLoadingIndicator();
                      }
                      if (chatProvider.isTyping &&
                          index == chatProvider.messages.length) {
                        return _buildTypingIndicator();
                      }
                      final messageIndex = _isLoadingMore ? index - 1 : index;
                      final message = chatProvider.messages[messageIndex];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/chat_empty.png',
            width: 150,
            height: 150,
          ),
          SizedBox(height: 16),
          Text(
            'ابدأ محادثتك مع المساعد التاريخي',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
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
    final user = Provider.of<UserProvider>(context).user;

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
              padding: EdgeInsets.all(14),
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
                textDirection: TextDirection.rtl,
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
                backgroundColor: Colors.white,
                backgroundImage:
                    AssetImage(user?.avatar ?? 'assets/avatars/default.png')),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: null, // Allows unlimited vertical expansion
                minLines: 1, // Start with a single line
                keyboardType: TextInputType.multiline,
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
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                ),
                onSubmitted: _handleSubmit,
              ),
            ),
            SizedBox(width: 5),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: Colors.brown,
              ),
              onPressed: () => _handleSubmit(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
