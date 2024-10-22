import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/quiz_confirmation_page.dart';
import 'package:quiz_app_flutter/models/colors.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textTitle,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SectionTitle(title: "General Quiz"),
            QuizCard(
              title: "General Quiz",
              details: "30 Questions (40 mins)",
              description: "A comprehensive general knowledge quiz with mixed difficulty levels.",
              quizId: 1,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Web Development"),
            QuizCard(
              title: "Web Development",
              details: "50 Questions (1 hour)",
              description: "A web development quiz with various difficulty levels.",
              quizId: 2,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Advanced Programming"),
            QuizCard(
              title: "Advanced Programming",
              details: "45 Questions (1 hour)",
              description: "An advanced programming quiz that covers a wide range of topics and difficulty levels.",
              quizId: 3,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Information Technology(General)"),
            QuizCard(
              title: "Information Technology",
              details: "45 Questions (1 hour)",
              description: "A general IT quiz featuring questions of various difficulty levels.",
              quizId: 4,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Cyber Security"),
            QuizCard(
              title: "Cyber Security",
              details: "45 Questions (1 hour)",
              description: "A cyber security quiz with mixed difficulty questions.",
              quizId: 5,
            ),
            SizedBox(height: 100),
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
  final String details;
  final String description;
  final int quizId;

  const QuizCard(
      {super.key,
      required this.title,
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
                      details: details,
                      description: description,
                      quizId: quizId, 
                      courseLevel: '',)));
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
            subtitle: Text(details),
          ),
        ));
  }
}
