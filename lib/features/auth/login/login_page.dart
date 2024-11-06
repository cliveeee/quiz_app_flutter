import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/components/my_button.dart';
import 'package:quiz_app_flutter/components/my_textfield.dart';
import 'package:quiz_app_flutter/navigation_page.dart';
import 'package:quiz_app_flutter/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() async {
    setState(() {
      _errorMessage = null; // Clear any previous error message
    });

    // Get email and password values
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Check for missing fields and set appropriate error message
    if (email.isEmpty && password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email and password.';
      });
      return;
    } else if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address.';
      });
      return;
    } else if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password.';
      });
      return;
    }

    // Display loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Attempt to log in with the provided credentials
    bool success = await AuthService().login(email, password);
    Navigator.of(context).pop(); // Remove the loading indicator

    // Handle login result
    if (success) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
    } else {
      setState(() {
        _errorMessage = 'Login failed. Email not found or incorrect password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  const Image(
                    image: AssetImage('images/logo.png'),
                    width: 300,
                    height: 300,
                  ),

                  // greeting text
                  const Text(
                    'Hello Again',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    'Welcome back, you\'ve been missed!',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 35),

                  // email textfield
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    onFieldSubmitted: (value) => _login(), // Trigger login on "Enter" for email
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    onFieldSubmitted: (value) => _login(), // Trigger login on "Enter" for password
                  ),
                  const SizedBox(height: 10),

                  // forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Error message display
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (_errorMessage != null) const SizedBox(height: 10),

                  // sign-in button
                  MyButton(
                    onTap: _login,
                    buttonText: "Sign In",
                  ),
                  const SizedBox(height: 30),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
