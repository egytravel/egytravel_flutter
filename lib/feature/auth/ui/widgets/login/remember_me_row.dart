import 'package:egytravel_app/core/theme/app_color.dart';
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
                activeColor: AppColor.primary,
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
            style: TextStyle(color: AppColor.primary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
