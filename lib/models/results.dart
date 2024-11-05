class QuizResult {
  final int score;
  final double percentage;
  final String recommendedCourse;

  QuizResult({
    required this.score,
    required this.percentage,
    required this.recommendedCourse,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['data']['score'],
      percentage: json['data']['percentage'],
      recommendedCourse: json['data']['recommendation']['certName'],
    );
  }
}
