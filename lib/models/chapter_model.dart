import 'package:flutter/material.dart';
import 'course_model.dart';

class Chapter {
  final String number;
  final String title;
  final List<Course> courses;
  final String backgroundImage;

  Chapter({
    required this.number,
    required this.title,
    required this.courses,
    required this.backgroundImage,
  });
}

class ChapterCard extends StatefulWidget {
  final Chapter chapter;

  ChapterCard({required this.chapter});

  @override
  _ChapterCardState createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    int completedCourses =
        widget.chapter.courses.where((course) => course.isCompleted).length;
    int totalCourses = widget.chapter.courses.length;

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.chapter.backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Part
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$completedCourses/$totalCourses',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Right Part
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.chapter.number}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                        ),
                      ),
                      Text(
                        widget.chapter.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'قراءة الدروس',
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Container(
                color: Color(
                    0xFFEBEBD3), // Ensure the list has a transparent background
                child: Column(
                  children: widget.chapter.courses.map((course) {
                    return CourseListItem(course: course);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
