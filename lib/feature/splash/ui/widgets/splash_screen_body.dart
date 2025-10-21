import 'package:egytravel_app/feature/splash/logic/controller/splash_controller.dart';
import 'package:egytravel_app/feature/splash/ui/widgets/bottom_loading.dart';
import 'package:egytravel_app/feature/splash/ui/widgets/decorative_circles.dart';
import 'package:egytravel_app/feature/splash/ui/widgets/main_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenBody extends GetView<SplashController> {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFDF2E0), Color(0xFFF5E6D3), Color(0xFFEDD5B8)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative rotating circles
            DecorativeCircles(controller: controller),

            // Main content
            MainContent(controller: controller),

            // Bottom loading section
            BottomLoading(controller: controller),
          ],
        ),
      ),
    );
  }
}
