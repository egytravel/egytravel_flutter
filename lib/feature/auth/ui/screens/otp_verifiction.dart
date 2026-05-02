import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/auth/logic/controller/otp_controller.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/auth_background.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/otp/otp_input.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
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
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomBackButton(),
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
                Obx(
                  () => Text(
                    'OTP code has been sent to ${controller.contact}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                  ),
                ),

                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OtpInput(
                      controller: controller.otp1Controller,
                      focusNode: controller.focusNode1,
                      nextFocusNode: controller.focusNode2,
                      autoFocus: true,
                    ),
                    const SizedBox(width: 6),
                    OtpInput(
                      controller: controller.otp2Controller,
                      focusNode: controller.focusNode2,
                      nextFocusNode: controller.focusNode3,
                    ),
                    const SizedBox(width: 6),
                    OtpInput(
                      controller: controller.otp3Controller,
                      focusNode: controller.focusNode3,
                      nextFocusNode: controller.focusNode4,
                    ),
                    const SizedBox(width: 8),
                    OtpInput(
                      controller: controller.otp4Controller,
                      focusNode: controller.focusNode4,
                      nextFocusNode: controller.focusNode5,
                    ),
                    const SizedBox(width: 8),
                    OtpInput(
                      controller: controller.otp5Controller,
                      focusNode: controller.focusNode5,
                      nextFocusNode: controller.focusNode6,
                    ),
                    const SizedBox(width: 8),
                    OtpInput(
                      controller: controller.otp6Controller,
                      focusNode: controller.focusNode6,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend code ',
                        style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                      ),
                      Obx(
                        () => TextButton(
                          onPressed: controller.isTimerRunning.value
                              ? null
                              : () => controller.resendCode(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                          ),
                          child: Text(
                            controller.isTimerRunning.value
                                ? '00:${controller.timerSeconds.value.toString().padLeft(2, '0')}s'
                                : 'Resend Now',
                            style: TextStyle(
                              fontSize: 14,
                              color: controller.isTimerRunning.value
                                  ? AppColor.primary
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.submitOTP(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
