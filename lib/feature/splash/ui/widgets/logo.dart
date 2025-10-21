import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.controller});

  final controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.scaleAnimation.value,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF8B6F47,
                  ).withOpacity(0.3 * controller.pulseAnimation.value),
                  // blurRadius: 40 * controller.pulseAnimation.value,
                  // spreadRadius: 10 * controller.pulseAnimation.value,
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF8B6F47), width: 3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(15),
                child: ClipOval(
                  child: Image.asset(
                    'assets/image/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
