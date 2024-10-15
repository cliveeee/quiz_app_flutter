import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app_flutter/login_or_register.dart';
import 'package:quiz_app_flutter/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> testAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return false;
  }

  var res = await http.get(
    Uri.parse('http://plums.test/api/v1/mobile/profile'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    },
  );

  if (res.statusCode == 200) {
    return true;
  }

  if (res.statusCode == 401) {
    logUserOut();
  }

  return false;
}

Future<bool> logUserOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return false;
  }

  await http.post(
    Uri.parse('http://plums.test/api/v1/mobile/logout'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    },
  );

  prefs.remove('accessToken');
  return true;
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      return await testAccessToken();
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
