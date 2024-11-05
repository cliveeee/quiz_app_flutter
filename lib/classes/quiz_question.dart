class QuizQuestion {
  final String question;
  final int questionId;
  final List<Answer> answers;
  int? selectedAnswer;

  QuizQuestion(
      {required this.question,
      required this.questionId,
      required this.answers,
      this.selectedAnswer});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = (json['answers'] as List)
        .map((answerJson) => Answer.fromJson(answerJson))
        .toList();

    return QuizQuestion(
        question: json['question'],
        questionId: json['id'],
        answers: answers,
        selectedAnswer: answers[0].id);
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
