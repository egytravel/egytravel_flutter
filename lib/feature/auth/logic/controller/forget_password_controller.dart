import 'package:egytravel_app/feature/auth/ui/screens/otp_verifiction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final selectedMethod = 'sms'.obs;

  void selectSMS() => selectedMethod.value = 'sms';
  void selectEmail() => selectedMethod.value = 'email';

  void sendOTP() {
    String contact = selectedMethod.value == 'sms'
        ? phoneController.text
        : emailController.text;

    if (contact.isNotEmpty) {
      Get.to(() => const OTPVerificationScreen());
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}