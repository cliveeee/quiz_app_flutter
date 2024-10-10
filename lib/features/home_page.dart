import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/classes/UserProfile.dart';
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:quiz_app_flutter/services/profile/profile_service.dart';
import 'package:quiz_app_flutter/widgets/courses_we_offer.dart';
import 'package:quiz_app_flutter/widgets/news_card.dart';
import 'package:quiz_app_flutter/models/articles_model.dart';

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
      backgroundColor: TColor.textTitle,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 15,
              // ),
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
                          fontSize: 22,
                        ),
                      ),
                      const Text(
                        "Great to see you again!",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple,
                    backgroundImage: _userProfile?.profileImageUrl != null &&
                            _userProfile!.profileImageUrl != ""
                        ? NetworkImage(
                            'http://plums.test/${_userProfile!.profileImageUrl}')
                        : null,
                    child: _userProfile?.profileImageUrl == null ||
                            _userProfile!.profileImageUrl == ""
                        ? const CircleAvatar(
                            radius: 24,
                            child: Icon(
                              Icons.camera_alt,
                              size: 25,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Courses we offer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const CoursesCard(),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Notice Board!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: ArticleModel.articles.length,
                      itemBuilder: (context, index) {
                        return const NewsCard();
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
