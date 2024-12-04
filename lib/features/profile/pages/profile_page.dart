import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/features/auth/auth_handler.dart';
import 'package:quiz_app_flutter/classes/UserProfile.dart';
import 'package:quiz_app_flutter/features/profile/pages/edit_profile_page.dart';
import 'package:quiz_app_flutter/models/colors.dart';
import 'package:quiz_app_flutter/services/profile/profile_service.dart';
import 'package:quiz_app_flutter/features/auth/pages/change_password_page.dart';
import 'package:quiz_app_flutter/services/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  UserProfile? _userProfile;
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
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
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.deepPurple,
                backgroundImage: _userProfile?.profileImageUrl != null &&
                        _userProfile?.profileImageUrl != ""
                    ? NetworkImage(
                        'http://192.168.90.201:8000/${_userProfile?.profileImageUrl}')
                    : null,
                child: _userProfile?.profileImageUrl == null ||
                        _userProfile?.profileImageUrl == ""
                    ? const CircleAvatar(
                        radius: 60,
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 15),
              Text(
                '${_userProfile?.firstName ?? "Unknown"} ${_userProfile?.lastName ?? "Unknown"} ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _userProfile?.email ?? "N/A",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              const Divider(
                height: 3,
                thickness: 3,
              ),
              const SizedBox(height: 15),

              // Edit Profile Row
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(userProfile: _userProfile!),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 28,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              // Change Password Row
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 28,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              // Help & Support Row
              InkWell(
                onTap: () async {
                  final Uri url = Uri.parse(
                      'https://help.screencraft.net.au/help/2680392001');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.help,
                        size: 28,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Help & Support",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              const Divider(
                height: 3,
                thickness: 3,
              ),
              const SizedBox(height: 15),

              // Logout Row
              InkWell(
                onTap: () async {
                  await _authService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 28,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
