import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../models/course_model.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_scaffold.dart';
import 'quiz_screen.dart';
import 'dart:developer' as developer;

class FlashcardPage extends StatefulWidget {
  final Course course;

  FlashcardPage({required this.course});

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  late List<String> _cardsContent;
  int _currentIndex = 0;
  bool _isGeneratingQuiz = false;

  @override
  void initState() {
    super.initState();
    _cardsContent = _splitContent(widget.course.content);
    _generateQuizInBackground(); // Ensure this is called
  }

  Future<void> _generateQuizInBackground() async {
    setState(() => _isGeneratingQuiz = true);
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        final quizProvider = Provider.of<QuizProvider>(context, listen: false);
        developer.log('Generating quiz for course: ${widget.course.id}');
        developer.log('Course content: ${widget.course.content}');
        await quizProvider.getQuizForCourse(
          widget.course.id,
          widget.course.content,
          user.level,
          user.year,
        );
        developer.log('Quiz generation completed');
      }
    } catch (e) {
      developer.log('Error generating quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ في توليد الاختبار',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isGeneratingQuiz = false);
  }

  void _navigateToQuiz() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return;

    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    try {
      final quiz = await quizProvider.getQuizForCourse(
        widget.course.id,
        widget.course.content,
        user.level,
        user.year,
      );

      developer.log('Navigating to QuizPage with quiz: ${quiz.title}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            quiz: quiz,
            course: widget.course,
          ),
        ),
      );
    } catch (e) {
      developer.log('Error navigating to QuizPage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ في تحميل الاختبار',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<String> _splitContent(String content) {
    return content.split('---').map((section) => section.trim()).toList();
  }

  void _nextCard() async {
    if (_currentIndex < _cardsContent.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Navigate to QuizPage with quiz data
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        final quizProvider = Provider.of<QuizProvider>(context, listen: false);
        try {
          final quiz = await quizProvider.getQuizForCourse(
            widget.course.id,
            widget.course.content,
            user.level,
            user.year,
          );

          developer.log('Navigating to QuizPage with quiz: ${quiz.title}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                quiz: quiz,
                course: widget.course,
              ),
            ),
          );
        } catch (e) {
          developer.log('Error navigating to QuizPage: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'حدث خطأ في تحميل الاختبار',
                textAlign: TextAlign.right,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Center(child: Text('No user data available'));
    }

    double progress = (_currentIndex + 1) / _cardsContent.length;

    return CustomScaffold(
      title: "البطاقات",
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Markdown(
                      data: _cardsContent[_currentIndex],
                      styleSheet: MarkdownStyleSheet(
                        h1: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        h2: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        h3: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                        p: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                        strong: TextStyle(fontWeight: FontWeight.bold),
                        blockquote: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                        code: TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                          color: Colors.blueGrey,
                        ),
                        listBullet: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      selectable: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Color(0xFF4A0E5C).withOpacity(0.25),
              color: Color(0xFF7A6C5D),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${_currentIndex + 1} / ${_cardsContent.length}',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF11144C),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A6C5D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    _currentIndex < _cardsContent.length - 1
                        ? 'التالي'
                        : 'إجراء إمتحان',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _previousCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A6C5D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'السابق',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
