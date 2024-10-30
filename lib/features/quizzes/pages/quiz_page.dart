import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/quiz_confirmation_page.dart';
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool isLoading = true;
  String? error;
  List<Map<String, dynamic>> staticQuizzes = [];
  List<Map<String, dynamic>> dynamicQuizzes = [];

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    setState(() {
      isLoading = true; // Set loading state at the beginning
      error = null; // Clear any previous error messages
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        setState(() {
          error = 'Please login to continue';
          isLoading = false; // Loading complete
        });
        return; // Exit the function if access token is null
      }

      final response = await http.get(
        Uri.parse('http://plums.test/api/v1/mobile/quizzes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          setState(() {
            staticQuizzes =
                List<Map<String, dynamic>>.from(data['data']['static'] ?? []);
            dynamicQuizzes =
                List<Map<String, dynamic>>.from(data['data']['dynamic'] ?? []);
            isLoading = false; // Loading complete
          });
        } else {
          setState(() {
            error = 'Invalid data format';
            isLoading = false; // Loading complete
          });
        }
      } else {
        setState(() {
          error =
              'Failed to load quizzes. Status code: ${response.statusCode}'; // Include status code for more context
          isLoading = false; // Loading complete
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e'; // Include error message for debugging
        isLoading = false; // Loading complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textTitle,
      appBar: AppBar(
        title: const Text('Available Quizzes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: fetchQuizzes,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchQuizzes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          if (staticQuizzes.isNotEmpty) ...[
            const SectionTitle(title: "Static Quizzes"),
            ...staticQuizzes.map((quiz) => QuizCard(
                  title: quiz['title'] ?? '',
                  description:
                      quiz['description'] ?? 'No description available',
                  quizId: quiz['id'] ?? 0,
                )),
            const SizedBox(height: 20),
          ],
          if (dynamicQuizzes.isNotEmpty) ...[
            const SectionTitle(title: "Dynamic Quizzes"),
            ...dynamicQuizzes.map((quiz) => QuizCard(
                  title: quiz['title'] ?? '',
                  description:
                      quiz['description'] ?? 'No description available',
                  quizId: quiz['id'] ?? 0,
                )),
            const SizedBox(height: 20),
          ],
          if (staticQuizzes.isEmpty && dynamicQuizzes.isEmpty)
            const Center(child: Text('No quizzes available')),
          const SizedBox(height: 100),
        ],
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

  final String description;
  final int quizId;

  const QuizCard({
    super.key,
    required this.title,
    required this.description,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizDetailPage(
              title: title,
              description: description,
              quizId: quizId,
              courseLevel: '',
            ),
          ),
        );
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
        ),
      ),
    );
  }
}
