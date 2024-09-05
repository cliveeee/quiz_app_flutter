import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const Padding(
        padding: EdgeInsets.all(14.0),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 45,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi Clive,",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        "Great to see you again!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: CircleAvatar(
                      radius: 34,
                      child: Icon(
                        Icons.camera_alt,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
