/*import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
import 'quiz_screen.dart';

class ChapterScreen extends StatefulWidget {
  final ChapterCard chapter;

  ChapterScreen({required this.chapter});

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.title),
        backgroundColor: Color(0xFF7A6C5D),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.chapter.content.length,
            backgroundColor: Colors.grey[300],
            color: Color(0xFFC17C74),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: widget.chapter.content.length,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.chapter.content[index],
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF7A6C5D)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_currentIndex == widget.chapter.content.length - 1)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizScreen(chapterId: widget.chapter.id)),
                );
              },
              child: Text('Start Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC17C74),
              ),
            ),
        ],
      ),
    );
  }
}
*/
