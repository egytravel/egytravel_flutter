import 'package:egytravel_app/feature/auth/ui/screens/forget_password_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RememberMeRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberMeRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.grey[400]),
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF6C5CE7),
                checkColor: Colors.white,
              ),
            ),
            Text('Remember Me', style: TextStyle(fontSize: 14, color: Colors.grey[300])),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const ForgotPasswordScreen());
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 14),
          ),
        ),
      ],
    );
  }
}
