import 'package:flutter/material.dart';

import '../screens/flashcard_screen.dart';
import '../services/notification_service.dart';
import '../widgets/study_tracker.dart';
import 'quiz_model.dart';

class Course {
  final String number;
  final String title;
  bool isCompleted;
  final String content;
  final Quiz quiz;

  Course({
    required this.number,
    required this.title,
    this.isCompleted = false,
    this.content = '',
    required this.quiz,
  });

  void markAsCompleted() async {
    isCompleted = true;
    quiz.score =
        quiz.questions.length; // Update the score to full marks on completion
    // Record study session and check streak
    await StudyTracker.recordStudySession();
    final streak = await StudyTracker.getStudyStreak();

    if (streak > 0 && streak % 3 == 0) {
      // Notify every 3 days of streak
      await StudyNotificationService().notifyStudyStreak(streak);
    }
  }
}

class CourseListItem extends StatelessWidget {
  final Course course;

  CourseListItem({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardPage(course: course),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(Icons.chevron_left_rounded, color: Colors.black, size: 40),
                if (course.isCompleted)
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'النتيجة: ${course.quiz.score}/${course.quiz.questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الوضعية التعليمية ${course.number}',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF999999)),
                        ),
                        Text(
                          course.title,
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
                    CustomPaint(
                      size: Size(50, 50),
                      painter: ProgressCirclePainter(
                          isCompleted: course.isCompleted),
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
