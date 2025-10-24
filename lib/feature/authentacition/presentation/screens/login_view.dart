import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egytravel_app/feature/authentacition/logic/controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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
                const SizedBox(height: 20),
                const TravoLogo(),
                const SizedBox(height: 30),
                const LoginHeader(),
                const SizedBox(height: 22),
                const SocialLoginButtons(),
                const SizedBox(height: 16),
                const OrDivider(),
                const SizedBox(height: 16),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      EmailInput(controller: controller.emailController),
                      const SizedBox(height: 16),
                      Obx(
                            () => PasswordInput(
                          controller: controller.passwordController,
                          obscurePassword: controller.obscurePassword.value,
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
                        ? controller.login
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
                const RegisterPrompt(),
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
        const Text(
          'EgyTravel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6C5CE7),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's get you Login!",
          style: TextStyle(
            fontSize: 24,
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

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            imageName: 'assets/image/logo_google-.png',
            label: 'Google',
            sizeImage: 28,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SocialButton(
            imageName: 'assets/image/facebook.png',
            sizeImage: 24,
            label: 'Facebook',

            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String imageName;
  final String label;
  final double sizeImage;

  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.imageName,
    required this.label,

    required this.sizeImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.grey, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageName, width: sizeImage,),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Or Login With', style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter Email Address',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onToggleVisibility;

  const PasswordInput({
    super.key,
    required this.controller,
    required this.obscurePassword,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter Password',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
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

class RememberMeRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberMeRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF6C5CE7),
            ),
            const Text('Remember Me', style: TextStyle(fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;

  const LoginButton({super.key, required this.onPressed, required this.enabled});

  @override
  Widget build(BuildContext context) {
    final buttonColor = enabled
        ? AppColor.primary
        : Colors.grey[300];

    final textColor = enabled ? Colors.white : Colors.grey[600];

    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPrompt extends StatelessWidget {
  const RegisterPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account? ",
              style: TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Register Now',
              style: TextStyle(
                color: Color(0xFF6C5CE7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
