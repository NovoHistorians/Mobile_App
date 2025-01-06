import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:novo_historians/screens/chatbot_screen.dart';
import 'package:provider/provider.dart';
import '../models/chapter_model.dart';
import '../providers/content_provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/study_tracker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Chapter> _chapters = [];
  String _loadingMessage = 'جاري التحميل...';
  @override
  void initState() {
    super.initState();
    _checkUserAndLoadContent();
  }

  Future<void> _checkUserAndLoadContent() async {
    try {
      final stopwatch = Stopwatch()..start();
      setState(() => _loadingMessage = 'جاري التحقق من المستخدم...');

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.initializeUser();

      print('User initialization took: ${stopwatch.elapsed.inMilliseconds}ms');

      if (userProvider.user != null) {
        await _loadContent();
      }

      stopwatch.stop();
      print('Total initialization took: ${stopwatch.elapsed.inMilliseconds}ms');
    } catch (e) {
      print('Error checking user: $e');
      setState(() => _loadingMessage = 'حدث خطأ في التحميل');
    }
  }

  Future<void> _loadContent() async {
    try {
      setState(() => _loadingMessage = 'جاري تحميل المحتوى...');
      final stopwatch = Stopwatch()..start();

      final user = Provider.of<UserProvider>(context, listen: false).user;
      print('Loading content for user: ${user?.level} - ${user?.year}');

      if (user != null) {
        final contentProvider =
            Provider.of<ContentProvider>(context, listen: false);
        final chapters =
            await contentProvider.getChapters(user.level, user.year);
        print('Content loading took: ${stopwatch.elapsed.inMilliseconds}ms');

        setState(() {
          _chapters = chapters;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading content: $e');
      setState(() {
        _isLoading = false;
        _loadingMessage = 'حدث خطأ في تحميل المحتوى';
      });
    }
  }

  Future<void> _initializeNotifications() async {
    final notificationService = StudyNotificationService();
    await notificationService.initializeNotifications();

    // Check for inactivity and schedule reminders
    StudyTracker.checkInactivity().then((inactive) {
      if (inactive) {
        notificationService.notifyInactivity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              _loadingMessage,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Center(child: Text('No user data available'));
    }
    return CustomScaffold(
      title: "الدروس",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/welcome');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    backgroundColor: Color(0xFF7A6C5D),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    'تغيير',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 15, color: Color(0xFFFFFFFF)),
                  ),
                ),
                Text(
                  'السنة ${user.year}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _chapters.length,
              itemBuilder: (context, index) {
                return ChapterCard(chapter: _chapters[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          // Navigate to chatbot page
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotScreen(),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle, // Creates a circular shape
              color: Colors.white, // Customize border color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Customize shadow color
                  blurRadius: 5, // Customize shadow blur
                  offset: Offset(0, 3), // Customize shadow position
                )
              ]),
          // Ensures the child fits within the circular shape
          child: Image.asset(
            'assets/images/chat.png',
            width: 60, // Matches default FAB size
            height: 60,
            fit: BoxFit.contain, // Ensures the image covers the space properly
          ),
        ), // Customize background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
