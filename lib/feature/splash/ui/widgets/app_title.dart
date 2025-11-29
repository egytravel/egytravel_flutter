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
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.white,
              letterSpacing: 1.5,
              height: 1.2,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Explore the Land of Pharaohs',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Colors.white60,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
