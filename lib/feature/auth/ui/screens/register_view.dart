import 'package:egytravel_app/feature/auth/logic/controller/register_controller.dart';
import 'package:egytravel_app/feature/auth/ui/screens/login_view.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/login_prompt_registerView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const TravoLogo(),
                const SizedBox(height: 24),
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
      ),
    );
  }
}

class TravoLogo extends StatelessWidget {
  const TravoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/image/logo.png', width: 100),
        const SizedBox(height: 8),
        const Text(
          'EgyTravel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6C5CE7),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register your account',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Enter your information below',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const RegisterButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? const Color(0xFF6C5CE7)
              : Colors.grey[300],
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isEnabled ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}


