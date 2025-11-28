import 'package:egytravel_app/feature/auth/logic/binding/register_binding.dart';
import 'package:egytravel_app/feature/auth/ui/screens/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPrompt extends StatelessWidget {
  const RegisterPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account? ", style: TextStyle(fontSize: 14, color: Colors.grey[300])),
          TextButton(
            onPressed: () {
              Get.to(() => const RegisterScreen(), binding: RegisterBinding());
            },
            child: const Text(
              'Register Now',
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
