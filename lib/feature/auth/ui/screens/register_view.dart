import 'package:egytravel_app/core/widgets/build_loading_overlay.dart';
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
    // If you haven't put it in bindings, ensure it's put. Assuming it's put.
    return AuthBackground(
      child: Obx(
        () => Stack(
          children: [
            AbsorbPointer(
              absorbing: controller.isLoading.value,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const RegisterHeader(),
                      const SizedBox(height: 20),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: controller.nameController,
                              label: 'Name',
                              hint: 'Name',
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.emailController,
                              label: 'Email Address',
                              hint: 'email@gmail.com',
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
                                onToggleVisibility:
                                    controller.togglePasswordVisibility,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => PasswordTextField(
                                controller: controller.rePasswordController,
                                label: 'Re-Enter Password',
                                hint: '••••••••',
                                obscureText: controller.obscureRePassword.value,
                                onToggleVisibility:
                                    controller.toggleRePasswordVisibility,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => RegisterButton(
                          isEnabled: controller.isFormValid.value,
                          onPressed: () => controller.register(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const LoginPrompt(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value)
              buildLoadingOverlay(controller.isLoading.value, true),
          ],
        ),
      ),
    );
  }
}


