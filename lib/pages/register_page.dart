import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/components/my_button.dart';
import 'package:quiz_app_flutter/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome Text
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),

                const Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 50),

                // Firstname textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Firstname',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Lastname textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Lastname',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: ' Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                MyButton(
                  onTap: signUserUp,
                  buttonText: "Sign Up",
                ),

                const SizedBox(height: 30),

                // already a member? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
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
    );
  }
}
