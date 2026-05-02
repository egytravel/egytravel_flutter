import 'dart:async';
import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/feature/auth/data/repo/auth_repo.dart';
import 'package:egytravel_app/feature/auth/logic/binding/new_password_binding.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/auth/ui/screens/new_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
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

  final contact = ''.obs;
  final isLoading = false.obs;
  
  // Timer logic
  final timerSeconds = 50.obs;
  final isTimerRunning = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    contact.value = Get.arguments?['contact'] ?? '';
    startTimer();
  }

  void startTimer() {
    isTimerRunning.value = true;
    timerSeconds.value = 50;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        isTimerRunning.value = false;
        _timer?.cancel();
      }
    });
  }

  Future<void> resendCode(BuildContext context) async {
    if (isTimerRunning.value) return;

    try {
      isLoading.value = true;
      await _authRepo.forgotPassword(email: contact.value);
      showTopGlassSnackBar(context, 'New code sent successfully', success: true);
      startTimer();
    } on ApiError catch (e) {
      showTopGlassSnackBar(context, e.message);
    } catch (e) {
      showTopGlassSnackBar(context, 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  void submitOTP(BuildContext context) {
    String otp =
        otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;

    if (otp.length != 6) {
      showTopGlassSnackBar(context, 'Please enter a valid 6-digit OTP');
      return;
    }

    // Since the backend verifies OTP during the reset-password call,
    // we navigate directly to the next screen.
    Get.to(
      () => const EnterNewPasswordScreen(),
      binding: NewPasswordBinding(),
      arguments: {
        'contact': contact.value,
        'otp': otp,
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
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
