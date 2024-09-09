import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/pages/quiz_confirmation_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SectionTitle(title: "Web Development"),
            QuizCard(
              title: "Web Development",
              courseLevel: "Certificate III",
              details: "15 Questions (20 mins)",
              description: "This is a description",
              quizId: 1,
            ),
            QuizCard(
              title: "Web Development",
              courseLevel: "Certificate IV",
              details: "30 Questions (40 mins)",
              description: "This is a description",
              quizId: 2,
            ),
            QuizCard(
              title: "Web Development",
              courseLevel: "Diploma",
              details: "50 Questions (1 hour)",
              description: "This is a description",
              quizId: 3,
            ),
            SizedBox(height: 20),
            SectionTitle(title: "Advanced Programming"),
            QuizCard(
              title: "Advanced Programming",
              courseLevel: "Certificate IV",
              details: "25 Questions (30 mins)",
              description: "This is a description",
              quizId: 4,
            ),
            QuizCard(
              title: "Advanced Programming",
              courseLevel: "Diploma",
              details: "45 Questions (1 hour)",
              description: "This is a description",
              quizId: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final String courseLevel;
  final String details;
  final String description;
  final int quizId;

  const QuizCard(
      {super.key,
      required this.title,
      required this.courseLevel,
      required this.details,
      required this.description,
      required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizDetailPage(
                      title: title,
                      courseLevel: courseLevel,
                      details: details,
                      description: description,
                      quizId: quizId)));
        },
        child: Card(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.school, size: 40, color: Colors.black),
            title: Text(title),
            subtitle: Text('$courseLevel = $details'),
          ),
        ));
  }
}
