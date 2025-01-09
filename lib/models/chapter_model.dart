import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import 'course_model.dart';

class Chapter {
  final String id;
  final String number;
  final String title;
  final List<Course> courses;
  final String backgroundImage;

  Chapter({
    required this.id,
    required this.number,
    required this.title,
    required this.courses,
    required this.backgroundImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'courses': courses.map((course) => course.toJson()).toList(),
      'backgroundImage': backgroundImage,
    };
  }

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      courses: (json['courses'] as List)
          .map((course) => Course.fromJson(course as Map<String, dynamic>))
          .toList(),
      backgroundImage: json['backgroundImage'],
    );
  }
}

class ChapterCard extends StatefulWidget {
  final Chapter chapter;
  final String userId;

  ChapterCard({required this.chapter, required this.userId});

  @override
  _ChapterCardState createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  bool _isExpanded = false;
  bool _isLoading = true;
  int _completedCourses = 0;

  @override
  void initState() {
    super.initState();
    _fetchChapterProgress();
  }

  Future<void> _fetchChapterProgress() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch progress for all courses in the chapter
    for (var course in widget.chapter.courses) {
      await course.fetchUserProgress(widget.userId);
    }

    // Recalculate completed courses
    _updateCompletedCourses();

    setState(() {
      _isLoading = false;
    });
  }

  void _updateCompletedCourses() {
    setState(() {
      _completedCourses =
          widget.chapter.courses.where((course) => course.isCompleted).length;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: _isLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : Text(
                            '$_completedCourses/$totalCourses',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                color: Color(0xFFEBEBD3),
                child: Column(
                  children: widget.chapter.courses.asMap().entries.map((entry) {
                    int index = entry.key;
                    Course course = entry.value;
                    bool isPreviousCourseCompleted = index == 0
                        ? true // The first course is always accessible
                        : widget.chapter.courses[index - 1].isCompleted; // Check if the previous course is completed
                    return CourseListItem(
                      course: course,
                      userId: widget.userId,
                      onCompletionChanged: () {
                        _updateCompletedCourses();
                        Provider.of<ContentProvider>(context, listen: false)
                            .notifyListeners();
                      },
                      isPreviousCourseCompleted: isPreviousCourseCompleted, // Pass the status
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
