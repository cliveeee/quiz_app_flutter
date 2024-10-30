class QuizQuestion {
  final String question;
  final List<Answer> answers;

  QuizQuestion({
    required this.question,
    required this.answers,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = (json['answers'] as List)
        .map((answerJson) => Answer.fromJson(answerJson))
        .toList();
    return QuizQuestion(
      question: json['question'],
      answers: answers,
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
    return answer.toString();
  }
}
