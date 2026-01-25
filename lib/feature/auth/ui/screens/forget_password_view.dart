import 'package:egytravel_app/feature/auth/logic/controller/forget_password_controller.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/forget_password/contact_method_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

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
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select which contact details should we use to reset your password',
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
                      'assets/image/forget-password.jpeg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.lock_reset, size: 80, color: Colors.white);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() => ContactMethodCard(
                  icon: Icons.sms_outlined,
                  title: 'Send OTP via SMS',
                  subtitle: '(+20) 111-252-252',
                  isSelected: controller.selectedMethod.value == 'sms',
                  onTap: controller.selectSMS,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                )),
                const SizedBox(height: 16),
                Obx(() => ContactMethodCard(
                  icon: Icons.email_outlined,
                  title: 'Send OTP via Email',
                  subtitle: 'fadi.atef@example.com',
                  isSelected: controller.selectedMethod.value == 'email',
                  onTap: controller.selectEmail,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                )),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Send OTP',
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