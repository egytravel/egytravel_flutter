import 'package:egytravel_app/feature/auth/logic/controller/otp_controller.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/otp/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OTPController());

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
                  'Enter OTP Code',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'OTP code has been sent to (316) 555-0116',
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
                      'assets/image/otp_image.jpeg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.lock_clock, size: 80, color: Colors.white);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInput(
                      controller: controller.otp1Controller,
                      focusNode: controller.focusNode1,
                      nextFocusNode: controller.focusNode2,
                      autoFocus: true,
                    ),
                    OtpInput(
                      controller: controller.otp2Controller,
                      focusNode: controller.focusNode2,
                      nextFocusNode: controller.focusNode3,
                    ),
                    OtpInput(
                      controller: controller.otp3Controller,
                      focusNode: controller.focusNode3,
                      nextFocusNode: controller.focusNode4,
                    ),
                    OtpInput(
                      controller: controller.otp4Controller,
                      focusNode: controller.focusNode4,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend code ',
                        style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                      ),
                      TextButton(
                        onPressed: controller.resendCode,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text(
                          '00:50s',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6C5CE7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitOTP,
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