import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class BottomLoading extends StatelessWidget {
  const BottomLoading({super.key, this.controller});

  final controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: controller.fadeInAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: controller.fadeInAnimation,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.brown.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColor.primary,
                      ),
                      minHeight: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading Experience...',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.black.withValues(alpha: 0.4),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
