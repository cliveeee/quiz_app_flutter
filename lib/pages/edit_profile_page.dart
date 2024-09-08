import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController(text: 'Clive Chipunzi');
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _phoneNumberController = TextEditingController(text: '+61 412 345 678');
  final TextEditingController _emailController = TextEditingController(text: 'iammcsaint@gmail.com');
  final TextEditingController _userNameController = TextEditingController(text: 'clive_chi');

  DateTime? _selectedDate; 
  String _selectedGender = 'Male';
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _genderController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 25),
            const Divider(height: 3, thickness: 3),
            const SizedBox(height: 25),

            // Full Name Input
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
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
                items: ['Male', 'Female', 'Other'].map((String value) {
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
            const SizedBox(width: 15), // 간격 추가

            // Birthday Input
            Expanded(
              child: TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context), // DatePicker 호출
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                      : '01/Jan/1990', // 초기 값 설정
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
            TextFormField(
              controller: _userNameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 15,
                ),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
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
