import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';

class TravoLogo extends StatelessWidget {
  const TravoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.zero,
          width: 200,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.imageLogo)),
          ),
        ),
        const Text(
          'EgyTravel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Changed to white for dark background
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
