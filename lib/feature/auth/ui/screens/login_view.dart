import 'package:egytravel_app/core/widgets/build_loading_overlay.dart';
import 'package:egytravel_app/feature/auth/logic/controller/login_controller.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/email_input.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/login_button.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/login_header.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/or_divider.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/password_input.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/register_prompt.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/remember_me_row.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/social_login_buttons.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login/travo_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
                      const LoginHeader(),
                      const SizedBox(height: 32),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            EmailInput(
                              controller: controller.emailController,
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => PasswordInput(
                                controller: controller.passwordController,
                                obscurePassword:
                                    controller.obscurePassword.value,
                                onToggleVisibility:
                                    controller.togglePasswordVisibility,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => RememberMeRow(
                          value: controller.rememberMe.value,
                          onChanged: controller.setRememberMe,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => LoginButton(
                          onPressed: controller.isButtonEnabled.value
                              ? () => controller.login(context)
                              : () {
                            Get.snackbar(
                              'Warning',
                              'Please fill in both email and password',
                              backgroundColor: Colors.orangeAccent,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(12),
                            );
                          },

                          enabled: controller.isButtonEnabled.value,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const OrDivider(),
                      const SizedBox(height: 16),
                      const SocialLoginButtons(),
                      const SizedBox(height: 24),
                      const RegisterPrompt(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            // Loading Overlay
            if (controller.isLoading.value)
              buildLoadingOverlay(controller.isLoading.value, true),
          ],
        ),
      ),
    );
  }
}
