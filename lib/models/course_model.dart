import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/error_message.dart';
import '../screens/flashcard_screen.dart';
import 'quiz_model.dart';

class Course {
  final String id;
  final String number;
  final String title;
  bool isCompleted;
  final String content;
  final Quiz quiz;

  Course({
    required this.id,
    required this.number,
    required this.title,
    this.isCompleted = false,
    this.content = '',
    required this.quiz,
  });

  Future<void> fetchUserProgress(String userId) async {
    try {
      final progressDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(id)
          .get();

      if (progressDoc.exists) {
        final progressData = progressDoc.data()!;
        isCompleted = progressData['isCompleted'] ?? false;
        quiz.score = progressData['quizScore'] ?? 0;
      } else {
        isCompleted = false; // Default to not completed if no progress exists
        quiz.score = 0; // Default to 0 score if no quiz data exists
      }
    } catch (e) {
      print('Error fetching user progress: $e');
      isCompleted = false; // Fallback in case of error
      quiz.score = 0; // Fallback in case of error
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'isCompleted': isCompleted,
      'content': content,
      'quiz': quiz.toJson(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      content: json['content'],
      quiz: Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
    );
  }
}

class CourseListItem extends StatefulWidget {
  final Course course;
  final String userId;
  final VoidCallback? onCompletionChanged;
  final bool isPreviousCourseCompleted; // Add this parameter

  CourseListItem({
    required this.course,
    required this.userId,
    this.onCompletionChanged,
    required this.isPreviousCourseCompleted, // Add this parameter
  });

  @override
  _CourseListItemState createState() => _CourseListItemState();
}

class _CourseListItemState extends State<CourseListItem> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseProgress();
  }

  Future<void> _fetchCourseProgress() async {
    setState(() {
      _isLoading = true;
    });

    await widget.course.fetchUserProgress(widget.userId);

    setState(() {
      _isLoading = false;
    });

    // Notify parent about completion status change
    if (widget.onCompletionChanged != null) {
      widget.onCompletionChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isPreviousCourseCompleted
          ? () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardPage(course: widget.course),
                ),
              );
            }
          : () {
              SamsungNotification.show(
                context,
                message: 'يجب إكمال الدرس السابق قبل البدء في هذا الدرس',
                icon: Icons.error_outline,
                duration: const Duration(seconds: 3),
              );
            }, // Disable navigation if previous course is not completed
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _isLoading
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      Icon(Icons.chevron_left_rounded,
                          color: Colors.black, size: 40),
                      // Always show the StarRating widget
                      Container(
                        alignment: Alignment.topCenter,
                        child: StarRating(
                          score: widget.course.quiz.score,
                          totalQuestions: widget.course.quiz.questions.length,
                          isCompleted:
                              widget.course.isCompleted, // Pass isCompleted
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'الوضعية التعليمية ${widget.course.number}',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF999999)),
                              ),
                              Text(
                                widget.course.title,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          _isLoading
                              ? CircularProgressIndicator() // Show loading indicator
                              : CustomPaint(
                                  size: Size(50, 50),
                                  painter: ProgressCirclePainter(
                                      isCompleted: widget.course.isCompleted),
                                ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final bool isCompleted;

  ProgressCirclePainter({required this.isCompleted});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isCompleted ? Color(0xFF71E9AF) : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint fillPaint = Paint()
      ..color =
          isCompleted ? Color(0xFF71E9AF).withOpacity(0.35) : Color(0xFFEEF0F7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, fillPaint);

    if (isCompleted) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.check.codePoint),
          style: TextStyle(
            fontSize: size.width * 0.6,
            fontFamily: Icons.check.fontFamily,
            color: Colors.green,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        size.center(Offset.zero) -
            Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class StarRating extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final bool isCompleted; // Add isCompleted parameter

  StarRating({
    required this.score,
    required this.totalQuestions,
    required this.isCompleted, // Pass isCompleted from CourseListItem
  });

  int get starCount {
    if (!isCompleted) return 0; // Return 0 stars if the course is not completed
    final percentage = (score / 5) * 100;
    if (percentage >= 80) return 3;
    if (percentage >= 60) return 2;
    if (percentage >= 40) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          size: 20,
          color: index < starCount
              ? Color(0xFFFFD700) // Gold color for filled stars
              : Colors.grey.withOpacity(0.3), // Grey for empty stars
        );
      }),
    );
  }
}
