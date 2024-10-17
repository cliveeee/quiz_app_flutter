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

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Display loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      String email = _emailController.text;
      String password = _passwordController.text;

      bool success = await AuthService().login(email, password);
      Navigator.of(context).pop();

      if (success) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NavigationPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed, please try again.')));
      }
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

                  // hello again
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
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    onFieldSubmitted: (value) => _login(), // Triggers login on "Enter"

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

                  // if (_errorMessage != null)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //     child: Text(
                  //       _errorMessage!,
                  //       style: const TextStyle(
                  //         color: Colors.red,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),

                  // if (_errorMessage != null) const SizedBox(height: 10),

                  // sign in button
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}