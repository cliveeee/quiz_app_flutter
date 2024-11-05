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

    int correctIndex = json['correct'].isNotEmpty ? json['correct'][0] - 1 : -1;

    return QuizQuestion(
      question: json['question'],
      answers: answers,
      correctAnswerIndex: correctIndex,
    );
  }
}

class Answer {
  final String answer;

  Answer({required this.answer});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'],
    );
  }

  @override
  String toString() {
    return answer;
  }
}
