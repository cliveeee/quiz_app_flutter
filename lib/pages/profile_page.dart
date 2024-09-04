import 'package:flutter/material.dart';

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
      body: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
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
              SizedBox(
                height: 15,
              ),
              Text(
                'Clive Chipunzi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'iammcsaint@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Divider(
                height: 3,
                thickness: 3,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 28,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Settings",
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 28,
                    ),
                    SizedBox(
                      width: 12,
                    ),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.help,
                      size: 28,
                    ),
                    SizedBox(
                      width: 12,
                    ),
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
              SizedBox(
                height: 25,
              ),
              Divider(
                height: 3,
                thickness: 3,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 28,
                    ),
                    SizedBox(
                      width: 12,
                    ),
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
