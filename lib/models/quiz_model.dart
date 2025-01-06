// quiz_model.dart

class Question {
  final String id;
  final String questionText;
  final List<String> choices;
  final String correctAnswer;

  Question({
    required this.id,
    required this.questionText,
    required this.choices,
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'choices': choices,
      'correctAnswer': correctAnswer,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      choices: List<String>.from(json['choices']),
      correctAnswer: json['correctAnswer'] as String,
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  int score;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    this.score = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
      'score': score,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      score: json['score'] as int,
    );
  }
}
