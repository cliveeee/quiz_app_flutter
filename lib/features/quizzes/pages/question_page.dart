import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:quiz_app_flutter/widgets/list_tile.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/completion_page.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  final String courseLevel;
  final int courseId;
  final int certificateId;
  final int quizId;

  const QuestionsPage({
    super.key,
    required this.title,
    required this.courseLevel,
    required this.courseId,
    required this.certificateId,
    required this.quizId,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int? selectedIndex;
  List<dynamic> questions = [];
  String? currentQuestionText;
  List<dynamic> answerOptions = [];
  bool isLoading = true; 


@override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/v1/mobile/courses/${widget.courseId}/certificates/${widget.certificateId}/questions/${widget.quizId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          questions = data;
          if (questions.isNotEmpty) {
            currentQuestionText = questions[0]['question_text'];
            answerOptions = questions[0]['answers']; 
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print(e);
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 35),
                  // Purple container for the question
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
                            currentQuestionText ?? 'Loading question...', 
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
                  
                  // Answer options
                  Expanded(
                    child: ListView.builder(
                      itemCount: answerOptions.length,
                      itemBuilder: (context, index) {
                        return AnswerTile(
                          answerText: answerOptions[index]['answer_text'], 
                          isSelected: selectedIndex == index,
                          onChanged: (value) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          answerType: AnswerType.radio,
                        );
                      },
                    ),
                  ),
                  
                  // Buttons at the bottom
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
                              // Add action for Prev button
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
                            onPressed: () {
                              // Add action for Submit button

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompletionPage(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
                              // Add action for Next button
                            },
                            child: const Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}