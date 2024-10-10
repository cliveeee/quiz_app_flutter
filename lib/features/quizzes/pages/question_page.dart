import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:quiz_app_flutter/widgets/list_tile.dart';
import 'package:quiz_app_flutter/features/quizzes/pages/completion_page.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  final String courseLevel;

  const QuestionsPage({
    super.key,
    required this.title,
    required this.courseLevel,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int? selectedIndex;

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
      body: Padding(
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
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Which soccer team won the FIFA World Cup for the first time?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Answer options
            Expanded(
              child: ListView(
                children: [
                  AnswerTile(
                    answerText: 'Brazil',
                    isSelected: selectedIndex == 0,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    answerType: AnswerType.radio,
                  ),
                  AnswerTile(
                    answerText: 'Germany',
                    isSelected: selectedIndex == 1,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    answerType: AnswerType.radio,
                  ),
                  AnswerTile(
                    answerText: 'Italy',
                    isSelected: selectedIndex == 2,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    answerType: AnswerType.radio,
                  ),
                  AnswerTile(
                    answerText: 'Argentina',
                    isSelected: selectedIndex == 3,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                    answerType: AnswerType.radio,
                  ),
                ],
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
                      child:
                          const Icon(Icons.chevron_left, color: Colors.white),
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
                      child:
                          const Icon(Icons.chevron_right, color: Colors.white),
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
