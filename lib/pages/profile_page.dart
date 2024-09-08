import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // Assuming you have created this page
import 'change_password_page.dart'; // Create this page for "Change Password"
import 'help_support_page.dart'; // Create this page for "Help & Support"

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              const CircleAvatar(
                radius: 65,
                backgroundColor: Colors.deepPurple,
                child: CircleAvatar(
                  radius: 60,
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Clive Chipunzi',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'iammcsaint@gmail.com',
                style: TextStyle(
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
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: const [
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: const [
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
              const Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: const [
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
            ],
          ),
        ),
      ),
    );
  }
}
