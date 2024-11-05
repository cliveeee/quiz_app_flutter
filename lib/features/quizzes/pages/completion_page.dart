import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiz_app_flutter/models/results.dart';
import 'package:quiz_app_flutter/classes/quiz_question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final Duration timeTaken;
  final int quizId;
  final List<QuizQuestion> questions;
  final List<int?> selectedIndexes;

  const ResultPage({
    Key? key,
    required this.score,
    required this.timeTaken,
    required this.quizId,
    required this.questions,
    required this.selectedIndexes,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<QuizResult> futureResult;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initFutureResult();
  }

  Future<void> _initFutureResult() async {
    try {
      final result = await submitQuizResult(
        quizId: widget.quizId,
        questions: widget.questions,
        selectedIndexes: widget.selectedIndexes,
      );
      setState(() {
        isLoading = false;
        errorMessage = null;
        futureResult = Future.value(result);
      });
    } catch (e) {
      print('Error submitting quiz result: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to submit quiz result: $e';
      });
    }
  }

  Future<QuizResult> submitQuizResult({
    required int quizId,
    required List<QuizQuestion> questions,
    required List<int?> selectedIndexes,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Please login to continue');
    }

    final response = await http.post(
      Uri.parse('http://plums.test/api/v1/mobile/quizzes/submit'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'courseId': quizId,
        'answers': List.generate(
          questions.length,
          (index) => {
            'questionId': index + 1,
            'answerId': selectedIndexes[index],
          },
        ),
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return QuizResult.fromJson(decodedResponse);
    } else {
      throw Exception('Failed to submit quiz result: ${response.statusCode}');
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.score.toString())),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.score.toString())),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initFutureResult,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<QuizResult>(
      future: futureResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.score.toString())),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.score.toString())),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _initFutureResult,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          final result = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quiz Results'),
              backgroundColor: Colors.deepPurple,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: ${result.data.score}/${result.data.totalScore}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Percentage: ${result.data.percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Recommended Course:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    result.data.recommendation.certName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Time Taken: ${formatDuration(widget.timeTaken)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Return to Home'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
