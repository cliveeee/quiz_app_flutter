import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:quiz_app_flutter/widgets/list_tile.dart';
import 'package:quiz_app_flutter/classes/quiz_question.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/completion_page.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  final String courseLevel;

  const QuestionsPage({
    Key? key,
    required this.title,
    required this.courseLevel,
  }) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int currentQuestionIndex = 0;
  int? selectedIndex;
  List<QuizQuestion> questions = [];
  bool isLoading = true;
  late Timer _timer;
  Duration _timeLeft = const Duration(minutes: 20); // Initial countdown duration
  int score = 0; // Initialize score

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse('http://plums.test/api/v1/quiz-questions'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          questions = jsonResponse.map((question) => QuizQuestion.fromJson(question)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching questions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds == 0) {
        _timer.cancel();
        // Navigate to completion page when time is up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompletionPage(
              score: score,
              timeTaken: Duration(minutes: 20),
            ),
          ),
        );
      } else {
        setState(() {
          _timeLeft -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void submitAnswer() {
    if (selectedIndex != null) {
      // Map selected index to the corresponding answer option (A, B, C, or D)
      String selectedAnswer;
      switch (selectedIndex) {
        case 0:
          selectedAnswer = questions[currentQuestionIndex].optionA;
          break;
        case 1:
          selectedAnswer = questions[currentQuestionIndex].optionB;
          break;
        case 2:
          selectedAnswer = questions[currentQuestionIndex].optionC;
          break;
        case 3:
          selectedAnswer = questions[currentQuestionIndex].optionD;
          break;
        default:
          selectedAnswer = '';
      }

      // Check if the selected answer is correct and update the score
      if (questions[currentQuestionIndex].correctAnswer == selectedAnswer) {
        score++;
      }
    }

    // Check if it's the last question
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedIndex = null; // Reset selection for the next question
      });
    } else {
      // Navigate to completion page if it's the last question
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompletionPage(
            score: score,
            timeTaken: Duration(minutes: 20) - _timeLeft,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textTitle,
      appBar: AppBar(
        backgroundColor: TColor.textTitle,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Text(
              widget.courseLevel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                formatTime(_timeLeft), // Display the countdown timer
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 35),
                  if (questions.isNotEmpty) ...[
                    Card(
                      color: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              questions[currentQuestionIndex].questionText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: ListView(
                        children: [
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionA,
                            isSelected: selectedIndex == 0,
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionB,
                            isSelected: selectedIndex == 1,
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionC,
                            isSelected: selectedIndex == 2,
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionD,
                            isSelected: selectedIndex == 3,
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = 3;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (currentQuestionIndex > 0) {
                                    currentQuestionIndex--;
                                    selectedIndex = null; // Reset selection for the previous question
                                  }
                                });
                              },
                              child: const Icon(Icons.chevron_left, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: submitAnswer,
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (currentQuestionIndex < questions.length - 1) {
                                    currentQuestionIndex++;
                                    selectedIndex = null; // Reset selection for the next question
                                  }
                                });
                              },
                              child: const Icon(Icons.chevron_right, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}