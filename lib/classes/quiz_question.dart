class QuizQuestion {
  final String question;
  final List<Answer> answers;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = (json['answers'] as List)
        .map((answerJson) => Answer.fromJson(answerJson))
        .toList();

    // Default to first answer if correct answer is not provided
    int correctIndex = 0;
    if (json.containsKey('correct_answer_index')) {
      correctIndex = json['correct_answer_index'];
    }

    return QuizQuestion(
      question: json['question'],
      answers: answers,
      correctAnswerIndex: correctIndex,
    );
  }
}

class Answer {
  final String answer;
  final int id;

  Answer({required this.answer, required this.id});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'],
      id: json['id'],
    );
  }

  @override
  String toString() {
    return answer;
  }
}
