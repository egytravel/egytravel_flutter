import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, this.controller});
final controller;
  @override
  Widget build(BuildContext context) {

      return Transform.translate(
        offset: Offset(0, controller.slideAnimation.value),
        child: Column(
          children: [
            const Text(
              'EgyTravel',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
                color: Color(0xFF2C1810),
                letterSpacing: 1.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B6F47),
                    Color(0xFFD4AF37),
                    Color(0xFF8B6F47),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Explore the Land of Pharaohs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: const Color(0xFF2C1810).withValues(alpha: 0.7),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );

  }
}
