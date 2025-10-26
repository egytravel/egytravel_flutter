import 'package:egytravel_app/feature/auth/logic/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OTPController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'OTP code has been sent to (316) 555-0116',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OTPBox(
                    controller: controller.otp1Controller,
                    focusNode: controller.focusNode1,
                    nextFocusNode: controller.focusNode2,
                  ),
                  OTPBox(
                    controller: controller.otp2Controller,
                    focusNode: controller.focusNode2,
                    nextFocusNode: controller.focusNode3,
                  ),
                  OTPBox(
                    controller: controller.otp3Controller,
                    focusNode: controller.focusNode3,
                    nextFocusNode: controller.focusNode4,
                  ),
                  OTPBox(
                    controller: controller.otp4Controller,
                    focusNode: controller.focusNode4,
                    nextFocusNode: controller.focusNode5,
                  ),
                  OTPBox(
                    controller: controller.otp5Controller,
                    focusNode: controller.focusNode5,
                    nextFocusNode: controller.focusNode6,
                  ),
                  OTPBox(
                    controller: controller.otp6Controller,
                    focusNode: controller.focusNode6,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Resend code ',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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
              Center(
                child: Image.asset(
                  'assets/image/otp_image.jpeg',
                  height: 250,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: 250,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                    );
                  },
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
    );
  }
}

class OTPBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final bool isLast;

  const OTPBox({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1 && !isLast) {
            nextFocusNode?.requestFocus();
          }
        },
      ),
    );
  }
}