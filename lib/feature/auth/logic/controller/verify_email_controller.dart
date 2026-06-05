import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  final otpController = TextEditingController();
  final isLoading = false.obs;
  final email = ''.obs;
  final AuthRepo _authRepo = AuthRepo();

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments as String? ?? '';
  }

  Future<void> verifyEmail(BuildContext context) async {
    if (otpController.text.isEmpty) {
      showTopGlassSnackBar(context, 'Please enter the OTP');
      return;
    }

    try {
      isLoading.value = true;
      await _authRepo.verifyEmail(
        email: email.value,
        otp: otpController.text.trim(),
      );

      showTopGlassSnackBar(
        context,
        'Email Verified Successfully',
        success: true,
      );

      Get.offAllNamed(Routes.loginScreen);
    } on ApiError catch (e) {
      showTopGlassSnackBar(context, e.message);
    } catch (e) {
      showTopGlassSnackBar(context, 'An error occurred during verification');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp(BuildContext context) async {
    try {
      isLoading.value = true;
      await _authRepo.resendOtp(email: email.value);
      showTopGlassSnackBar(
        context,
        'OTP resent to ${email.value}',
        success: true,
      );
    } on ApiError catch (e) {
      showTopGlassSnackBar(context, e.message);
    } catch (e) {
      showTopGlassSnackBar(context, 'Failed to resend OTP');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
