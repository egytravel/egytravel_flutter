import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/auth/data/repo/auth_repo.dart';
import 'package:egytravel_app/feature/auth/ui/screens/otp_verifiction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgotPasswordController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final selectedMethod = 'sms'.obs;
  final isLoading = false.obs;

  void selectSMS() => selectedMethod.value = 'sms';
  void selectEmail() => selectedMethod.value = 'email';

  Future<void> sendOTP(BuildContext context) async {
    String contact = (selectedMethod.value == 'sms'
        ? phoneController.text
        : emailController.text).trim();

    if (contact.isEmpty) {
      showTopGlassSnackBar(context, 'Please enter your ${selectedMethod.value}');
      return;
    }

    try {
      isLoading.value = true;
      await _authRepo.forgotPassword(email: contact);
      
      showTopGlassSnackBar(
        context, 
        'OTP sent successfully to your ${selectedMethod.value}',
        success: true,
      );
      
      Get.to(() => const OTPVerificationScreen(), arguments: {'contact': contact});
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
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}