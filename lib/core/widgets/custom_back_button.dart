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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: iconColor,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
