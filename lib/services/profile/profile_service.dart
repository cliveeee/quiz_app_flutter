import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:quiz_app_flutter/classes/UserProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  UserProfile? _cachedProfile;

  Future<UserProfile?> fetchUserProfile({bool forceRefresh = false}) async {
    if (_cachedProfile != null && !forceRefresh) {
      return _cachedProfile;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      return null;
    }

    try {
      final res = await http.get(
        Uri.parse('https://plums-2.screencraft.net.au/api/v1/mobile/profile'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      print(res.body);

      if (res.statusCode == 200) {
        _cachedProfile = UserProfile.fromJson(jsonDecode(res.body)['data']);
        return _cachedProfile;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<String?> updateProfilePicture(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      return null;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://plums-2.screencraft.net.au/api/v1/mobile/profile/photo'),
      );
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final res = await request.send();
      final response = await http.Response.fromStream(res);
      print(response.body);
      final responseBody = jsonDecode(response.body);

      if (res.statusCode == 200) {
        if (_cachedProfile != null) {
          _cachedProfile = _cachedProfile!.copyWith(
            profileImageUrl: responseBody['data']['url'],
          );
        }
        return responseBody['data']['url'];
      }

      return null;
    } catch (e) {
      print('Error updating profile picture: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(UserProfile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      return false;
    }

    try {
      final userJson = jsonEncode(profile.toJson());

      final res = await http.post(
          Uri.parse('https://plums-2.screencraft.net.au/api/v1/mobile/profile'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: userJson);

      print(userJson);
      print(res.statusCode);
      print(res.body);
      return true;
    } catch (e) {
      print('Error updating profile information: $e');
      return false;
    }
  }

  void clearCache() {
    _cachedProfile = null;
  }
}
