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
              courseLevel: "Certificate III",
              details: "10 Questions (15 mins)",
              description: "A basic general knowledge quiz to assess your understanding of common topics for Certificate III.",
              quizId: 1,
            ),
            QuizCard(
              title: "General Quiz",
              courseLevel: "Certificate IV",
              details: "20 Questions (25 mins)",
              description: "An intermediate general knowledge quiz covering topics for Certificate IV.",
              quizId: 2,
            ),
            QuizCard(
              title: "General Quiz",
              courseLevel: "Diploma",
              details: "30 Questions (40 mins)",
              description: "A comprehensive general knowledge quiz designed for Diploma level learners.",
              quizId: 3,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Web Development"),
            QuizCard(
              title: "Web Development",
              courseLevel: "Certificate III",
              details: "15 Questions (20 mins)",
              description: "An introductory quiz to test your basic knowledge in web development for Certificate III.",
              quizId: 4,
            ),
            QuizCard(
              title: "Web Development",
              courseLevel: "Certificate IV",
              details: "30 Questions (40 mins)",
              description: "An intermediate web development quiz aimed at Certificate IV students.",
              quizId: 5,
            ),
            QuizCard(
              title: "Web Development",
              courseLevel: "Diploma",
              details: "50 Questions (1 hour)",
              description: "An advanced quiz for web development students at the Diploma level.",
              quizId: 6,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Advanced Programming"),
            QuizCard(
              title: "Advanced Programming",
              courseLevel: "Certificate III",
              details: "20 Questions (30 mins)",
              description: "Test your basic programming skills with this quiz for Certificate III level.",
              quizId: 7,
            ),
            QuizCard(
              title: "Advanced Programming",
              courseLevel: "Certificate IV",
              details: "25 Questions (30 mins)",
              description: "An intermediate programming quiz to evaluate your skills for Certificate IV.",
              quizId: 8,
            ),
            QuizCard(
              title: "Advanced Programming",
              courseLevel: "Diploma",
              details: "45 Questions (1 hour)",
              description: "A challenging quiz designed to test Diploma level programming knowledge.",
              quizId: 9,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Information Technology(General)"),
            QuizCard(
              title: "Information Technology",
              courseLevel: "Certificate III",
              details: "20 Questions (30 mins)",
              description: "Basic IT concepts and knowledge quiz for Certificate III level students.",
              quizId: 10,
            ),
            QuizCard(
              title: "Information Technology",
              courseLevel: "Certificate IV",
              details: "25 Questions (30 mins)",
              description: "Intermediate IT concepts quiz for Certificate IV students.",
              quizId: 11,
            ),
            QuizCard(
              title: "Information Technology",
              courseLevel: "Diploma",
              details: "45 Questions (1 hour)",
              description: "Advanced IT quiz focused on core concepts for Diploma students.",
              quizId: 12,
            ),
            SizedBox(height: 20),
            
            SectionTitle(title: "Cyber Security"),
            QuizCard(
              title: "Cyber Security",
              courseLevel: "Certificate III",
              details: "20 Questions (30 mins)",
              description: "Basic cyber security quiz covering fundamental concepts for Certificate III students.",
              quizId: 13,
            ),
            QuizCard(
              title: "Cyber Security",
              courseLevel: "Certificate IV",
              details: "25 Questions (30 mins)",
              description: "Intermediate cyber security topics quiz aimed at Certificate IV students.",
              quizId: 14,
            ),
            QuizCard(
              title: "Cyber Security",
              courseLevel: "Diploma",
              details: "45 Questions (1 hour)",
              description: "Advanced cyber security concepts quiz for Diploma students.",
              quizId: 15,
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
