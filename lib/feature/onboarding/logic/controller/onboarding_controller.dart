import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final pageController = PageController();

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.home); // or
    }
  }

  void skipToEnd() {
    currentPage.value = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}