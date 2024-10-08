import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/classes/UserProfile.dart';
import 'package:quiz_app_flutter/services/profile/profile_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProfileService _profileService = ProfileService();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserProfile? profile = await _profileService.fetchUserProfile();
    setState(() {
      _userProfile = profile;
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
                        _userProfile != null
                            ? "Hello, ${_userProfile!.firstName}"
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
                    backgroundImage: _userProfile?.profileImageUrl != null &&
                            _userProfile!.profileImageUrl != ""
                        ? NetworkImage(
                            'http://plums.test/${_userProfile!.profileImageUrl}')
                        : null,
                    child: _userProfile?.profileImageUrl == null ||
                            _userProfile!.profileImageUrl == ""
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
