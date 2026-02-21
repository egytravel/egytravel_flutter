import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/background_widget.dart';
import 'package:egytravel_app/feature/splash/logic/controller/splash_controller.dart';
import 'package:egytravel_app/feature/splash/ui/widgets/bottom_loading.dart';
import 'package:egytravel_app/feature/splash/ui/widgets/main_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenBody extends GetView<SplashController> {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),

          // Main content
          MainContent(controller: controller),

          // Bottom loading section
          BottomLoading(controller: controller),
        ],
      ),
    );
  }
}
