import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Let's get you Login!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Changed to white
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your information below',
          style: TextStyle(fontSize: 16, color: Colors.grey[300]), // Changed to lighter grey
        ),
      ],
    );
  }
}
