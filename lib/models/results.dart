class QuizResult {
  final bool success;
  final String message;
  final ResultData data;

  QuizResult({
    required this.success,
    required this.message,
    required this.data,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      success: json['success'],
      message: json['message'],
      data: ResultData.fromJson(json['data']),
    );
  }
}

class ResultData {
  final String id;
  final Map<String, CertificateResult> results;
  final int score;
  final int totalScore;
  final double percentage;
  final RecommendedCourse recommendation;

  ResultData({
    required this.id,
    required this.results,
    required this.score,
    required this.totalScore,
    required this.percentage,
    required this.recommendation,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    Map<String, CertificateResult> resultsMap = {};
    (json['results'] as Map<String, dynamic>).forEach((key, value) {
      resultsMap[key] = CertificateResult.fromJson(value);
    });

    return ResultData(
      id: json['id'],
      results: resultsMap,
      score: json['score'],
      totalScore: json['totalScore'],
      percentage: json['percentage'].toDouble(),
      recommendation: RecommendedCourse.fromJson(json['recommendation']),
    );
  }
}

class CertificateResult {
  final String certName;
  final int threshold;
  final int score;
  final int totalScore;
  final List<int> correct;
  final List<IncorrectAnswer> incorrect;
  final double percentage;

  CertificateResult({
    required this.certName,
    required this.threshold,
    required this.score,
    required this.totalScore,
    required this.correct,
    required this.incorrect,
    required this.percentage,
  });

  factory CertificateResult.fromJson(Map<String, dynamic> json) {
    return CertificateResult(
      certName: json['certName'],
      threshold: json['threshold'],
      score: json['score'],
      totalScore: json['totalScore'],
      correct: List<int>.from(json['correct']),
      incorrect: (json['incorrect'] as List)
          .map((x) => IncorrectAnswer.fromJson(x))
          .toList(),
      percentage: json['percentage'].toDouble(),
    );
  }
}

class IncorrectAnswer {
  final Question question;
  final Answer submittedAnswer;
  final Answer correctAnswer;

  IncorrectAnswer({
    required this.question,
    required this.submittedAnswer,
    required this.correctAnswer,
  });

  factory IncorrectAnswer.fromJson(Map<String, dynamic> json) {
    return IncorrectAnswer(
      question: Question.fromJson(json['question']),
      submittedAnswer: Answer.fromJson(json['submittedAnswer']),
      correctAnswer: Answer.fromJson(json['correctAnswer']),
    );
  }
}

class Question {
  final int id;
  final String text;

  Question({required this.id, required this.text});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
    );
  }
}

class Answer {
  final int id;
  final String text;

  Answer({required this.id, required this.text});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      text: json['text'],
    );
  }
}

class RecommendedCourse {
  final int id;
  final String certName;

  RecommendedCourse({required this.id, required this.certName});

  factory RecommendedCourse.fromJson(Map<String, dynamic> json) {
    return RecommendedCourse(
      id: json['id'],
      certName: json['certName'],
    );
  }
}
