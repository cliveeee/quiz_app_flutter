import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app_flutter/services/profile/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    try {
      var res = await http.post(
        Uri.parse('http://plums.test/api/v1/mobile/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      print(res.body);
      var decoded = jsonDecode(res.body);

      if (res.statusCode == 200) {
        String? accessToken = decoded['data']['accessToken'];

        if (accessToken != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await ProfileService().fetchUserProfile(forceRefresh: true);
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> register(String firstname, String lastname, String email,
      String password, String passwordConfirmation) async {
    try {
      var res = await http.post(
        Uri.parse('http://plums.test/api/v1/mobile/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'first_name': firstname,
          'last_name': lastname,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation
        }),
      );

      var decoded = jsonDecode(res.body);

      if (res.statusCode == 201) {
        String? accessToken = decoded['data']['accessToken'];

        if (accessToken != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await ProfileService().fetchUserProfile(forceRefresh: true);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during registration: \$e');
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }
}
