import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/snak_bar.dart';
import 'package:egytravel_app/feature/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepo _authRepo = AuthRepo();
  final obscurePassword = true.obs;
  final rememberMe = false.obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;

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

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showTopGlassSnackBar(
        context,
        'Please fill in both email and password',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      showTopGlassSnackBar(
        context,
        'Invalid Email',
      );
      return;
    }

    if (password.length < 8) {
      showTopGlassSnackBar(
        context,
        'Password must be at least 8 characters',
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authRepo.login(email: email, password: password);

      showTopGlassSnackBar(
        context,
        'Login Successful',
        success: true,
      );

      Get.offAllNamed(Routes.home);

    } on ApiError catch (e) {
      showTopGlassSnackBar(
        context,
        e.message,
      );
      return;
    } catch (e) {
      showTopGlassSnackBar(
        context,
        'An error occurred during login',
      );
      return;
    } finally {
      isLoading.value = false;
    }
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
