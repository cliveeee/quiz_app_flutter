import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app_flutter/components/widgets/image_picker_action_sheet.dart';
import 'package:quiz_app_flutter/functions/auth.dart';
import 'package:quiz_app_flutter/pages/login_or_register.dart';
import 'package:quiz_app_flutter/services/media/media_service_interface.dart';
import 'package:quiz_app_flutter/services/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final DateTime? birthday;
  final String? profileImageUrl;

  const EditProfilePage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.birthday,
    this.profileImageUrl,
  }) : super(key: key);

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final MediaServiceInterface _mediaService = getIt<MediaServiceInterface>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _genderController;
  DateTime? _selectedDate;
  late String _selectedGender;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _genderController = TextEditingController(text: widget.gender);
    _selectedDate = widget.birthday;
    _selectedGender = widget.gender ?? "Undisclosed";
    _profileImageUrl = widget.profileImageUrl;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<AppImageSource?> _pickImageSource() async {
    AppImageSource? _appImageSource = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => ImagePickerActionSheet(),
    );
    if (_appImageSource != null) {
      _uploadImage(_appImageSource);
    }
  }

  Future _uploadImage(AppImageSource _appImageSource) async {
    final _pickedImageFile =
        await _mediaService.uploadImage(context, _appImageSource);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      var loggedOut = await logUserOut();

      if (loggedOut) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  const LoginOrRegisterPage()), // Replace with your actual RegisterPage widget
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    }

    if (_pickedImageFile != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://plums.test/api/v1/mobile/photo'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _pickedImageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var res = await request.send();
      var body = await http.Response.fromStream(res);
      var decoded = jsonDecode(body.body);

      if (res.statusCode == 200) {
        setState(() {
          _profileImageUrl = decoded['data']['url'];
        });

        prefs.setString('photo', _profileImageUrl ?? "");
        print('Uploaded photo: $_profileImageUrl!');
      } else {
        print(res.statusCode);
        print(decoded);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImageSource,
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Colors.deepPurple,
                backgroundImage:
                    _profileImageUrl != null && _profileImageUrl != ""
                        ? NetworkImage('http://plums.test/$_profileImageUrl')
                        : null,
                child: _profileImageUrl == null || _profileImageUrl == ""
                    ? const CircleAvatar(
                        radius: 60,
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '${widget.firstName ?? 'N/A'} ${widget.lastName ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.email ?? 'Unknown Email',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 25),
            const Divider(height: 3, thickness: 3),
            const SizedBox(height: 25),

            // First Name and Last Name in a Row
            Row(
              children: [
                // First Name Input
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Last Name Input
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Gender and Birthday in a Row
            Row(
              children: [
                // Gender Input
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['Male', 'Female', 'Undisclosed'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),

                // Birthday Input
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                          : '01/Jan/1990',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Birthday',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Phone Number Input
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Email Address Input
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // User Name Input
            // TextFormField(
            //   controller: _userNameController,
            //   decoration: const InputDecoration(
            //     labelText: 'User Name',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'email': _emailController.text,
                  'phoneNumber': _phoneNumberController.text,
                  // 'userName': _userNameController.text,
                  'gender': _selectedGender,
                  'birthday': _selectedDate ?? DateTime(1990, 1, 1),
                  'profileImageUrl': _profileImageUrl,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile updated successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 15,
                  ),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
