import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/functions/auth.dart';
import 'package:quiz_app_flutter/pages/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart'; // Assuming you have created this page
import 'change_password_page.dart'; // Create this page for "Change Password"
import 'help_support_page.dart'; // Create this page for "Help & Support"

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? firstName;
  String? lastName;
  String? email;
  String phoneNumber = '+61 412 345 678';
  String userName = 'clive_chi';
  String gender = 'Male';
  DateTime birthday = DateTime(1990, 1, 1);
  File? profileImage;

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
      email = prefs.getString('email');
    });
  }

  Future<void> _navigateAndUpdateProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          userName: userName,
          gender: gender,
          birthday: birthday,
          profileImage: profileImage,
        ),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        firstName = updatedProfile['firstName'] ?? firstName;
        lastName = updatedProfile['lastName'] ?? lastName;
        email = updatedProfile['email'] ?? email;
        phoneNumber = updatedProfile['phoneNumber'] ?? phoneNumber;
        userName = updatedProfile['userName'] ?? userName;
        gender = updatedProfile['gender'] ?? gender;
        birthday = updatedProfile['birthday'] ?? birthday;
        profileImage = updatedProfile['profileImage'] ?? profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.deepPurple,
                backgroundImage:
                    profileImage != null ? FileImage(profileImage!) : null,
                child: profileImage == null
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
                '$firstName $lastName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                email ?? "N/A",
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
                onTap: _navigateAndUpdateProfile,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 16,
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
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpSupportPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.help,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Help & Support",
                        style: TextStyle(
                          fontSize: 16,
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
                  await logUserOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Auth(),
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
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Logout",
                        style: TextStyle(
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
