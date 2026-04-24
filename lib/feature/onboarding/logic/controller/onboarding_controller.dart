import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final pageController = PageController();

  void nextPage() async {
    if (currentPage.value < 2) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      await SharedPreferencesHelper.setOnboardingCompleted();
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  void skipToEnd() async {
    await SharedPreferencesHelper.setOnboardingCompleted();
    Get.offAllNamed(Routes.loginScreen);
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