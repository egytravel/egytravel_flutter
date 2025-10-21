import 'package:egytravel_app/feature/splash/ui/widgets/app_title.dart';
import 'package:egytravel_app/feature/splash/ui/widgets/logo.dart';
import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key, this.controller});
final controller;
  @override
  Widget build(BuildContext context) {

      return Center(
        child: AnimatedBuilder(
          animation: controller.mainController,
          builder: (context, child) {
            return FadeTransition(
              opacity: controller.fadeInAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with pulsing glow
                  Logo(controller: controller),

                  const SizedBox(height: 50),

                  // App name with slide animation
                  AppTitle(controller: controller),
                ],
              ),
            );
          },
        ),
      );

  }
}
