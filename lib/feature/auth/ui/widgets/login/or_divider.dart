import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[400])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Or Login With', style: TextStyle(color: Colors.grey[300])),
        ),
        Expanded(child: Divider(color: Colors.grey[400])),
      ],
    );
  }
}
