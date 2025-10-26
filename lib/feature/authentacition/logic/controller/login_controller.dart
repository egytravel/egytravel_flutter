import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var obscurePassword = true.obs;
  var rememberMe = false.obs;
  var isButtonEnabled = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void setRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // ✅ دالة التحقق من صحة الإيميل
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // ✅ التحقق من صحة البيانات قبل تسجيل الدخول
  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 8 characters long',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }


    Get.snackbar(
      'Login Successful',
      'Welcome back, $email 👋',
      backgroundColor: AppColor.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );


  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_checkButtonStatus);
    passwordController.addListener(_checkButtonStatus);
  }

  void _checkButtonStatus() {
    isButtonEnabled.value =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
