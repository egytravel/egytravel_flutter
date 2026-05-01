import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/feature/auth/data/repo/auth_repo.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/bottom_sheet_suces_pass.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewPasswordController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureRePassword = true.obs;
  final isLoading = false.obs;

  late String contact;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    contact = Get.arguments?['contact'] ?? '';
    otp = Get.arguments?['otp'] ?? '';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRePasswordVisibility() {
    obscureRePassword.value = !obscureRePassword.value;
  }

  Future<void> submitNewPassword(BuildContext context) async {
    if (passwordController.text.isEmpty || rePasswordController.text.isEmpty) {
      showTopGlassSnackBar(context, 'Please fill all fields');
      return;
    }

    if (passwordController.text != rePasswordController.text) {
      showTopGlassSnackBar(context, 'Passwords do not match');
      return;
    }

    if (passwordController.text.length < 8) {
      showTopGlassSnackBar(context, 'Password must be at least 8 characters');
      return;
    }

    try {
      isLoading.value = true;
      await _authRepo.resetPassword(
        email: contact,
        otp: otp,
        newPassword: passwordController.text,
      );

      Get.back(); // Close screen if it was a bottom sheet or similar, but here it's a screen.
      // Actually, EnterNewPasswordScreen is a screen.
      
      Get.bottomSheet(
        const PasswordUpdateSuccessBottomSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        enableDrag: false,
      );
    } on ApiError catch (e) {
      showTopGlassSnackBar(context, e.message);
    } catch (e) {
      showTopGlassSnackBar(context, 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    rePasswordController.dispose();
    super.onClose();
  }
}