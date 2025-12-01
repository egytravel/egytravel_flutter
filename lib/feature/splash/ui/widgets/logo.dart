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
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(20),
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
