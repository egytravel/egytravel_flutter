import 'package:egytravel_app/feature/auth/logic/binding/new_password_binding.dart';
import 'package:egytravel_app/feature/auth/ui/screens/new_password.dart';
import 'package:egytravel_app/feature/auth/logic/controller/newPassword_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  final otp5Controller = TextEditingController();
  final otp6Controller = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();

  void submitOTP() {
    String otp =
        otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;

    if (otp.length == 6) {
      Get.to(
            () => const EnterNewPasswordScreen(),
        binding: NewPasswordBinding(),
      );

    }
  }

  void resendCode() {
    Get.snackbar(
      'OTP Sent',
      'New code has been sent',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    super.onClose();
  }
}
