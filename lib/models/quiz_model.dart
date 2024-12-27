class Quiz {
  final String title;
  final List<Question> questions;
  int score;

  Quiz({required this.title, required this.questions, this.score = 0});
}

class Question {
  final String questionText;
  final List<String> choices;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.choices,
    required this.correctAnswer,
  });
}
