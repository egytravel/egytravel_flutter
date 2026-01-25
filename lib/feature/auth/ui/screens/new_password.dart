import 'package:egytravel_app/feature/auth/logic/controller/newPassword_controller.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterNewPasswordScreen extends StatelessWidget {
  const EnterNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewPasswordController());

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter New Password',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please enter new password',
                  style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/image/enter_password.jpeg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.lock, size: 80, color: Colors.white);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() => PasswordField(
                  controller: controller.passwordController,
                  label: 'Password',
                  obscureText: controller.obscurePassword.value,
                  onToggle: controller.togglePasswordVisibility,
                )),
                const SizedBox(height: 16),
                Obx(() => PasswordField(
                  controller: controller.rePasswordController,
                  label: 'Re-Enter Password',
                  obscureText: controller.obscureRePassword.value,
                  onToggle: controller.toggleRePasswordVisibility,
                )),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitNewPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggle;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[300]),
        ),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: 8,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
