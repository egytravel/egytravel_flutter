import 'package:egytravel_app/feature/auth/logic/controller/register_controller.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/travo_logo.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/register/custom_text_field.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/register/login_prompt.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/register/password_text_field.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/register/register_button.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/register/register_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const RegisterHeader(),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.nameController,
                label: 'Name',
                hint: 'Fadi Atef',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.emailController,
                label: 'Email Address',
                hint: 'fadi.atef@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.phoneController,
                label: 'Mobile Number',
                hint: '(+20) 111-111-1111',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Obx(
                () => PasswordTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: controller.obscurePassword.value,
                  onToggleVisibility: controller.togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => PasswordTextField(
                  controller: controller.rePasswordController,
                  label: 'Re-Enter Password',
                  hint: '••••••••',
                  obscureText: controller.obscureRePassword.value,
                  onToggleVisibility: controller.toggleRePasswordVisibility,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => RegisterButton(
                  isEnabled: controller.isFormValid.value,
                  onPressed: controller.register,
                ),
              ),
              const SizedBox(height: 16),
              const LoginPrompt(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


