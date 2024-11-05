import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app_flutter/classes/quiz_question.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/completion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  final String courseLevel;
  final int quizId;
  final bool isDynamicViaCourseId;

  const QuestionsPage(
      {super.key,
      required this.title,
      required this.courseLevel,
      required this.quizId,
      this.isDynamicViaCourseId = false});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int currentQuestionIndex = 0;
  List<int?> selectedIndexes = [];
  List<QuizQuestion> questions = [];
  bool isLoading = true;
  String? errorMessage;
  final PageController _pageController = PageController();
  Duration remainingTime = const Duration(minutes: 20);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds == 0) {
        timer.cancel();
        submitQuiz();
      } else {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> fetchQuestions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please login to continue';
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://plums.test/api/v1/mobile/quizzes/generate?courseId=${widget.quizId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true &&
            jsonResponse['data'] != null &&
            jsonResponse['data'] is List) {
          List<dynamic> data = jsonResponse['data'];

          setState(() {
            questions = data
                .map((question) => QuizQuestion.fromJson(question))
                .toList();
            selectedIndexes = List.filled(questions.length, null);
            isLoading = false;
            errorMessage = null;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                jsonResponse['message'] ?? 'No questions found for this quiz.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load questions. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please check your connection.';
      });
    }
  }

  Future<void> submitQuiz() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        setState(() {
          errorMessage = 'Please login to continue';
        });
        return;
      }

      List<Map<String, int>> answers = [];
      for (int i = 0; i < questions.length; i++) {
        if (selectedIndexes[i] != null) {
          answers.add({
            'questionId': questions[i].questionId,
            'answerId': questions[i].answers[selectedIndexes[i]!].id,
          });
        }
      }

      if (answers.length != questions.length) {
        setState(() {
          errorMessage = 'Please answer all questions before submitting.';
        });
        return;
      }

      Map<String, dynamic> requestBody = {
        'answers': answers,
      };

      if (widget.isDynamicViaCourseId) {
        requestBody['courseId'] = widget.quizId;
      } else {
        requestBody['quizId'] = widget.quizId;
      }

      print(requestBody);

      final response = await http.post(
        Uri.parse('http://plums.test/api/v1/mobile/quizzes/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CompletionPage(response: json.decode(response.body)),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Failed to submit quiz. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'An error occurred during submission. Please check your connection.';
      });
    }
  }

  void _handleNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePreviousQuestion() {
    if (currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildQuestionCard(int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1} of ${questions.length}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              questions[index].question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: questions[index].answers.length,
                itemBuilder: (context, answerIndex) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: RadioListTile<int>(
                      title: Text(
                        questions[index].answers[answerIndex].answer,
                        style: const TextStyle(fontSize: 16),
                      ),
                      value: answerIndex,
                      groupValue: selectedIndexes[index],
                      onChanged: (value) {
                        setState(() {
                          selectedIndexes[index] = value;
                        });
                      },
                      activeColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed:
                currentQuestionIndex > 0 ? _handlePreviousQuestion : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: currentQuestionIndex < questions.length - 1
                ? _handleNextQuestion
                : submitQuiz,
            icon: const Icon(Icons.arrow_forward),
            label: Text(currentQuestionIndex == questions.length - 1
                ? 'Submit'
                : 'Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFormattedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchQuestions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                getFormattedTime(remainingTime),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentQuestionIndex = index;
          });
        },
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return _buildQuestionCard(index);
        },
      ),
      bottomNavigationBar: _buildNavigationButtons(),
    );
  }
}
