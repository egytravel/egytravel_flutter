import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureRePassword = true.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    rePasswordController.addListener(_validateForm);
  }


  void _validateForm() {
    isFormValid.value = nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        rePasswordController.text.isNotEmpty;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }


  void register() {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final rePassword = rePasswordController.text.trim();


    if (password != rePassword) {
      _showSnack('Password Mismatch', 'Passwords do not match');
      return;
    }


    _showSnack('Success', 'Registration successful!', success: true);
  }

  void _showSnack(String title, String message, {bool success = false}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }


  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void toggleRePasswordVisibility() =>
      obscureRePassword.value = !obscureRePassword.value;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.onClose();
  }
}
