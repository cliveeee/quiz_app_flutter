import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18), // Adjusted padding for size
        margin: const EdgeInsets.symmetric(
            horizontal: 20), // Adjusted margin for size
        decoration: BoxDecoration(
          color: Colors.deepPurple, // Changed button color
          borderRadius: BorderRadius.circular(12), // Adjusted border radius
        ),
        child: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15, // Adjusted font size
            ),
          ),
        ),
      ),
    );
  }
}
