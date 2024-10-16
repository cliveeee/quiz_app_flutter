import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/auth/auth_handler.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/question_page.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/quiz_page.dart';
import 'package:quiz_app_flutter/services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PLUMS',
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}
