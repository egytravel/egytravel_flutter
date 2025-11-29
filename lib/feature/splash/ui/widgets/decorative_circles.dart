import 'package:flutter/material.dart';

class DecorativeCircles extends StatelessWidget {
  const DecorativeCircles({super.key, this.controller});

  final controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: controller.rotateAnimation,
          builder: (context, child) {
            return Positioned(
              top: 100 + (index * 200.0),
              right: -50 + (index * 30.0),
              child: Transform.rotate(
                angle: (controller.rotateAnimation.value + index * 0.3) * 6.28,
                child: Container(
                  width: 150 - (index * 30.0),
                  height: 150 - (index * 30.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
