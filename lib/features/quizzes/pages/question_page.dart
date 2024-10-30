import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app_flutter/classes/quiz_question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  final String courseLevel;
  final int quizId;

  const QuestionsPage({
    Key? key,
    required this.title,
    required this.courseLevel,
    required this.quizId,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        Uri.parse('http://plums.test/api/v1/mobile/quizzes/${widget.quizId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];

        setState(() {
          questions =
              data.map((question) => QuizQuestion.fromJson(question)).toList();
          selectedIndexes = List.filled(questions.length, null);
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load questions. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please check your connection.';
      });
    }
  }

  void _handleNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePreviousQuestion() {
    if (currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildQuestionCard(int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 12),
            Text(
              questions[index].question,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: questions[index].answers.length,
                itemBuilder: (context, answerIndex) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: RadioListTile<int>(
                      title: Text(
                        questions[index].answers[answerIndex].answer,
                        style: TextStyle(fontSize: 16),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed:
                currentQuestionIndex > 0 ? _handlePreviousQuestion : null,
            icon: Icon(Icons.arrow_back),
            label: Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: currentQuestionIndex < questions.length - 1
                ? _handleNextQuestion
                : null,
            icon: Icon(Icons.arrow_forward),
            label: Text(currentQuestionIndex == questions.length - 1
                ? 'Submit'
                : 'Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage!,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchQuestions,
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  )
                : questions.isEmpty
                    ? Center(child: Text("No questions available"))
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              '${widget.courseLevel} Quiz',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: questions.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentQuestionIndex = index;
                                });
                              },
                              itemBuilder: (context, index) =>
                                  _buildQuestionCard(index),
                            ),
                          ),
                          _buildNavigationButtons(),
                        ],
                      ),
      ),
    );
  }
}
