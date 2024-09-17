import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> refreshUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return false;
  }

  var res = await http.get(
    Uri.parse('http://plums.test/api/v1/mobile/me'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    },
  );

  if (res.statusCode == 200) {
    var decoded = jsonDecode(res.body);

    String? email = decoded['data']['email'];
    String? firstName = decoded['data']['first_name'];
    String? lastName = decoded['data']['last_name'];

    if (email != null && firstName != null && lastName != null) {
      prefs.setString('email', email);
      prefs.setString('firstName', firstName);
      prefs.setString('lastName', lastName);
      return true;
    } else {
      print(res.statusCode);
      print(res.body);
    }
  }

  return false;
}

Future<bool> logUserOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  if (accessToken == null) {
    return false;
  }

  var res = await http.post(
    Uri.parse('http://plums.test/api/v1/mobile/logout'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    },
  );

  if (res.statusCode == 200) {
    prefs.remove('accessToken');
    return true;
  } else {
    print(res.statusCode);
    print(res.body);
  }

  return false;
}
