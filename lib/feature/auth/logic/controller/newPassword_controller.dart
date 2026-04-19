import 'package:egytravel_app/feature/auth/ui/widgets/bottom_sheet_suces_pass.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
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
      showError('Please fill all fields');
      return;
    }

    if (passwordController.text != rePasswordController.text) {
      showError('Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      showError('Password must be at least 6 characters');
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