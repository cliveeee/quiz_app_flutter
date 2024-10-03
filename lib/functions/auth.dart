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

    print(decoded);

    // String? username = decoded['data']['user_name'];
    String? firstName = decoded['data']['first_name'];
    String? lastName = decoded['data']['last_name'];
    String? email = decoded['data']['email'];
    String? phoneNumber = decoded['data']['phone_number'];
    String? birthDate = decoded['data']['birth_date'];
    String? gender = decoded['data']['gender'];
    String? photo = decoded['data']['photo'];

    // prefs.setString('username', username ?? "Unknown");
    prefs.setString('firstName', firstName ?? "Unknown");
    prefs.setString('lastName', lastName ?? "Unknown");
    prefs.setString('email', email ?? "Unknown");
    prefs.setString('phoneNumber', phoneNumber ?? "Unknown");
    prefs.setString('birthDate', birthDate ?? "Unknown");
    prefs.setString('gender', gender ?? "Unknown");
    prefs.setString('photo', photo ?? "");
    return true;
  } else {
    print(res.statusCode);
    print(res.body);
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

  var res = await http.post(
    Uri.parse('http://plums.test/api/v1/mobile/logout'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    },
  );

  prefs.remove('accessToken');
  return true;
}
