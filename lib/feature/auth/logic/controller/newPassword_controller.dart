import 'package:egytravel_app/feature/auth/ui/widgets/bottom_sheet_suces_pass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureRePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRePasswordVisibility() {
    obscureRePassword.value = !obscureRePassword.value;
  }

  void submitNewPassword() {
    if (passwordController.text.isEmpty || rePasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != rePasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }


    Get.back(); // Close bottom sheet
    Get.bottomSheet(

      const PasswordUpdateSuccessBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    rePasswordController.dispose();
    super.onClose();
  }
}