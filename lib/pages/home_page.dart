import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? firstName;
  String? lastName;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName');
      lastName = prefs.getString('lastName');
      profileImageUrl = prefs.getString('photo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 45,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName != null
                            ? "Hello, $firstName"
                            : "Hello, Unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const Text(
                        "Great to see you again!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.deepPurple,
                    backgroundImage: profileImageUrl != null &&
                            profileImageUrl != ""
                        ? NetworkImage('http://plums.test/${profileImageUrl}')
                        : null,
                    child: profileImageUrl == null || profileImageUrl == ""
                        ? const CircleAvatar(
                            radius: 34,
                            child: Icon(
                              Icons.camera_alt,
                              size: 35,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Courses we offer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
