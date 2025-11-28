import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(fontSize: 14, color: Colors.grey[300]),
        ),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: 10,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter Email Address',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
