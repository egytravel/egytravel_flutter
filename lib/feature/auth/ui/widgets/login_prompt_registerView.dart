import 'package:egytravel_app/feature/auth/ui/screens/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(fontSize: 14),
          ),
          TextButton(
            onPressed: () {
              Get.off(() => const LoginScreen());
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF6C5CE7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}