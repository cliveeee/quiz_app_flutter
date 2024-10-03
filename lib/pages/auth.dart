import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/functions/auth.dart';
import 'package:quiz_app_flutter/navigation_page.dart';
import 'package:quiz_app_flutter/pages/login_or_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    print(accessToken);

    if (accessToken != null) {
      await refreshUserInfo();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return const NavigationPage();
          } else {
            return const LoginOrRegisterPage();
          }
        }
      },
    );
  }
}
