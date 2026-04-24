import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
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
  final isLoading = false.obs;

  final AuthRepo _authRepo = AuthRepo();

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

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final rePassword = rePasswordController.text.trim();

    if (!_isValidEmail(email)) {
      showTopGlassSnackBar(context, 'Invalid Email');
      return;
    }

    if (!_isValidPhone(phone)) {
      showTopGlassSnackBar(context, 'Invalid Phone Number');
      return;
    }

    if (!_isValidPassword(password)) {
      showTopGlassSnackBar(context, 'Password must be at least 8 characters');
      return;
    }

    if (password != rePassword) {
      showTopGlassSnackBar(context, 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      final user = await _authRepo.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      showTopGlassSnackBar(
        context,
        'Registration Successful',
        success: true,
      );

      Get.offAllNamed(Routes.home);

    } on ApiError catch (e) {
      showTopGlassSnackBar(context, e.message);
    } catch (e) {
      showTopGlassSnackBar(context, 'An error occurred during registration');
    } finally {
      isLoading.value = false;
    }
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
