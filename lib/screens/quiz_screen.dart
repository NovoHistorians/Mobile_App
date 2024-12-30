import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:novo_historians/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../providers/user_provider.dart';
import '../models/course_model.dart';
import '../widgets/custom_scaffold.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;
  final Course course;

  QuizPage({required this.quiz, required this.course});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedChoice;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<bool> _answeredQuestions; // Track if questions have been answered

  @override
  void initState() {
    super.initState();
    _initAudio();
    _answeredQuestions = List<bool>.filled(widget.quiz.questions.length, false);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    // Pre-load audio files
    await _audioPlayer.setSource(AssetSource('sounds/correct.mp3'));
  }

  Future<void> _playSound(String soundType) async {
    try {
      switch (soundType) {
        case 'correct':
          await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
          break;
        case 'wrong':
          await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
          break;
        case 'complete':
          await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
          break;
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _checkAnswer() {
    if (_selectedChoice == null) return;

    bool isCorrect = _selectedChoice ==
        widget.quiz.questions[_currentQuestionIndex].correctAnswer;

    setState(() {
      // Check if the question is already answered
      if (!_answeredQuestions[_currentQuestionIndex]) {
        if (isCorrect) {
          _score++;
        }
        // Mark the question as answered
        _answeredQuestions[_currentQuestionIndex] = true;
      }
      // Play appropriate sound
      _playSound(isCorrect ? 'correct' : 'wrong');

      // Show custom dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildCustomDialog(isCorrect),
      );
    });
  }

  void _nextQuestion() {
    Navigator.of(context).pop(); // Close the dialog
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedChoice = null; // Reset selected choice for next question
      });
    } else {
      // Mark the course as completed and update the quiz score
      _playSound('complete');

      setState(() {
        widget.course.markAsCompleted();
        widget.quiz.score = _score;
      });

      // Show completion dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildCompletionDialog(),
      );
    }
  }

  Widget _buildCustomDialog(bool isCorrect) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isCorrect ? Colors.green[100] : Colors.red[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.close,
              color: isCorrect ? Colors.green : Colors.red,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              isCorrect ? '!ممتاز عمل رائع' : '!للأسف',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green[800] : Colors.red[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              isCorrect
                  ? '!أحسنت الإجابة صحيحة'
                  : 'الإجابة الصحيحة هي: ${widget.quiz.questions[_currentQuestionIndex].correctAnswer}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'مواصلة',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: Colors.blue[800],
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              '!أتممت الإمتحان',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'نتيجتك النهائية هي: $_score/${widget.quiz.questions.length}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'الرجوع إلى الدروس',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Center(child: Text('لا توجد معلومات حول المستخدم'));
    }
    double progress =
        (_currentQuestionIndex + 1) / widget.quiz.questions.length;

    return CustomScaffold(
      title: "الأسئلة",
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Color(0xFF4A0E5C).withOpacity(0.25),
              color: Color(0xFF7A6C5D),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Color(0xFFEBEBD3),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Card(
                          color: Color(0xFF7A6C5D),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.quiz.questions[_currentQuestionIndex]
                                  .questionText,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.quiz
                              .questions[_currentQuestionIndex].choices.length,
                          itemBuilder: (context, index) {
                            String choice = widget
                                .quiz
                                .questions[_currentQuestionIndex]
                                .choices[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedChoice == choice
                                      ? const Color(0xFF009688)
                                      : const Color(0xFFFFFFFF),
                                  foregroundColor: _selectedChoice == choice
                                      ? Colors.white
                                      : Colors.black,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedChoice = choice;
                                  });
                                },
                                child: Text(choice),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'النتيجة: $_score',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFF11144C),
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _selectedChoice != null ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _selectedChoice != null ? Color(0xFF7A6C5D) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'تحقق',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
