import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController mainController;
  late AnimationController pulseController;
  late AnimationController rotateController;

  // Animations
  late Animation<double> fadeInAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> slideAnimation;
  late Animation<double> pulseAnimation;
  late Animation<double> rotateAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Main animation controller
    mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Pulse animation for logo glow effect
    pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Subtle rotation for decorative elements
    rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Fade in animation
    fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Scale animation
    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: mainController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Slide animation
    slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulse animation
    pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Rotate animation
    rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      rotateController,
    );
  }

  void _startAnimationSequence() {
    // Start main animation
    mainController.forward();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 3800), () {
      navigateToHome();
    });
  }

  void navigateToHome() {
    Get.offAllNamed(Routes.onboardingScreen);
  }

  @override
  void onClose() {
    mainController.dispose();
    pulseController.dispose();
    rotateController.dispose();
    super.onClose();
  }
}