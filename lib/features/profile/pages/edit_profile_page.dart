import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/components/widgets/image_picker_action_sheet.dart';
import 'package:quiz_app_flutter/classes/UserProfile.dart';
import 'package:quiz_app_flutter/services/profile/profile_service.dart';
import 'package:quiz_app_flutter/services/media/media_service_interface.dart';
import 'package:quiz_app_flutter/services/service_locator.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfilePage({super.key, required this.userProfile});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final ProfileService _profileService = ProfileService();
  final MediaServiceInterface _mediaService = getIt<MediaServiceInterface>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late String _selectedGender;
  DateTime? _selectedDate;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userProfile.firstName);
    _lastNameController =
        TextEditingController(text: widget.userProfile.lastName);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneNumberController =
        TextEditingController(text: widget.userProfile.phoneNumber);
    _selectedGender = widget.userProfile.gender ?? "Undisclosed";
    _selectedDate = widget.userProfile.birthday;
    _profileImageUrl = widget.userProfile.profileImageUrl;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImageSource() async {
    AppImageSource? appImageSource = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => const ImagePickerActionSheet(),
    );
    if (appImageSource != null) {
      _uploadImage(appImageSource);
    }
  }

  Future<void> _uploadImage(AppImageSource appImageSource) async {
    final pickedImageFile =
        await _mediaService.uploadImage(context, appImageSource);

    if (pickedImageFile != null) {
      String? imageUrl =
          await _profileService.updateProfilePicture(pickedImageFile);
      if (imageUrl != null) {
        setState(() {
          _profileImageUrl = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
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
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveProfile() async {
    UserProfile updatedProfile = UserProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      gender: _selectedGender,
      birthday: _selectedDate,
      profileImageUrl: _profileImageUrl,
    );

    bool success = await _profileService.updateUserProfile(updatedProfile);
    if (success) {
      Navigator.pop(context, updatedProfile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile.')),
      );
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
                        child: Icon(Icons.camera_alt, size: 50),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Undisclosed'].map((String value) {
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
            const SizedBox(height: 15),
            TextFormField(
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select a date',
              ),
              decoration: const InputDecoration(
                labelText: 'Birthday',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
