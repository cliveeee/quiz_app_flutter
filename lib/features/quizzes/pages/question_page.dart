import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:quiz_app_flutter/widgets/list_tile.dart';
import 'package:quiz_app_flutter/classes/quiz_question.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/completion_page.dart';

class _QuestionsPageState extends State<QuestionsPage> {
  int currentQuestionIndex = 0;
  List<int?> selectedIndexes = []; // Stores selected indexes for all questions
  List<QuizQuestion> questions = [];
  bool isLoading = true;
  late Timer _timer;
  Duration _timeLeft = const Duration(minutes: 20); // Initial countdown duration
  int score = 0; // Initialize score
  bool quizCompleted = false; // Track if the quiz is completed

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
          selectedIndexes = List.filled(questions.length, null); // Initialize the selected index list
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
        navigateToCompletionPage();
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

  // Function to validate answers when quiz is complete
  void validateAnswers() {
    for (int i = 0; i < questions.length; i++) {
      if (selectedIndexes[i] != null) {
        String selectedAnswer;
        switch (selectedIndexes[i]) {
          case 0:
            selectedAnswer = questions[i].optionA;
            break;
          case 1:
            selectedAnswer = questions[i].optionB;
            break;
          case 2:
            selectedAnswer = questions[i].optionC;
            break;
          case 3:
            selectedAnswer = questions[i].optionD;
            break;
          default:
            selectedAnswer = '';
        }

        if (questions[i].correctAnswer == selectedAnswer) {
          score++;
        }
      }
    }
  }

  // Function to navigate to the completion page
  void navigateToCompletionPage() {
    validateAnswers(); // Calculate score before navigating
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

  // When the user presses "Submit"
  void submitAnswer() {
    if (selectedIndexes[currentQuestionIndex] == null) {
      // If no answer is selected, don't submit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You haven\'t finished the quiz, press the next arrow to continue'),
        ),
      );
      return; // Do nothing if no answer is selected
    }

    // Check if it's the last question
    if (currentQuestionIndex == questions.length - 1) {
      quizCompleted = true;
      navigateToCompletionPage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You haven\'t finished the quiz, press the next arrow to continue'),
        ));
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
                            isSelected: selectedIndexes[currentQuestionIndex] == 0,
                            onChanged: (value) {
                              setState(() {
                                selectedIndexes[currentQuestionIndex] = 0;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionB,
                            isSelected: selectedIndexes[currentQuestionIndex] == 1,
                            onChanged: (value) {
                              setState(() {
                                selectedIndexes[currentQuestionIndex] = 1;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionC,
                            isSelected: selectedIndexes[currentQuestionIndex] == 2,
                            onChanged: (value) {
                              setState(() {
                                selectedIndexes[currentQuestionIndex] = 2;
                              });
                            },
                            answerType: AnswerType.radio,
                          ),
                          AnswerTile(
                            answerText: questions[currentQuestionIndex].optionD,
                            isSelected: selectedIndexes[currentQuestionIndex] == 3,
                            onChanged: (value) {
                              setState(() {
                                selectedIndexes[currentQuestionIndex] = 3;
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

class QuestionsPage extends StatefulWidget {
  final String title;
  final String courseLevel;

  const QuestionsPage({super.key, required this.title, required this.courseLevel});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}
