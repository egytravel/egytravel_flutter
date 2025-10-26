import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final rememberMe = false.obs;
  final isButtonEnabled = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void setRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void login() {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack(
        'Error',
        'Please enter both email and password',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnack(
        'Invalid Email',
        'Please enter a valid email address',
      );
      return;
    }

    if (password.length < 8) {
      _showSnack(
        'Weak Password',
        'Password must be at least 8 characters long',
      );
      return;
    }

    _showSnack(
      'Login Successful',
      'Welcome back, $email 👋',
      success: true,
    );
  }

  void _showSnack(String title, String message, {bool success = false}) {
    Get.snackbar(
      title,
      message,
      backgroundColor:
      success ? AppColor.primary : Colors.redAccent.withValues( alpha:  0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
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
