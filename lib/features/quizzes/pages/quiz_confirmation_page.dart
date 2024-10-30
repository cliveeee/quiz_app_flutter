import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/question_page.dart';
import 'package:quiz_app_flutter/models/colors.dart';

class QuizDetailPage extends StatelessWidget {
  final String title;
  final String courseLevel;
  final String details;
  final String description;
  final int quizId;

  const QuizDetailPage({
    Key? key,
    required this.title,
    required this.courseLevel,
    required this.details,
    required this.description,
    required this.quizId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textTitle,
      appBar: AppBar(
        backgroundColor: TColor.textTitle,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              courseLevel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details: $details',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionsPage(
                  title: title,
                  courseLevel: courseLevel,
                  quizId: quizId, // Pass quizId to QuestionsPage
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Start Quiz",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
