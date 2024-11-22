import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/question_page.dart';
import 'package:quiz_app_flutter/models/colors.dart';

class QuizDetailPage extends StatelessWidget {
  final String title;
  final String courseLevel;
  final String description;
  final int quizId;
  final bool isDynamic;

  const QuizDetailPage({
    Key? key,
    required this.title,
    required this.courseLevel,
    required this.description,
    required this.quizId,
    required this.isDynamic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textTitle,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Confirm Quiz",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // const SizedBox(height: 10),
            // Text(
            //   'Course Level: $courseLevel',
            //   style: const TextStyle(fontSize: 16, color: Colors.black),
            // ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please confirm the details above and click "Start Quiz" to begin.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the previous page to edit
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Go back",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionsPage(
                        title: title,
                        courseLevel: courseLevel,
                        quizId: quizId,
                        isDynamicViaCourseId: isDynamic,
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
          ],
        ),
      ),
    );
  }
}
