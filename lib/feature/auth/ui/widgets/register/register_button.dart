import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const RegisterButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppColor.primary
              : Colors.grey[600],
          disabledBackgroundColor: Colors.grey[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isEnabled ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
