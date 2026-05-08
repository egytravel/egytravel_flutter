import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color iconColor;
  final double size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.iconColor = Colors.white,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Get.back(),
      child: Center( // Center to prevent it from stretching in AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(7), // Reduced from 10
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: iconColor,
                size: size - 2, // Slightly smaller icon
              ),
            ),
          ),
        ),
      ),
    );
  }
}
