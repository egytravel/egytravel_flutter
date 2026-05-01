import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final controller = Get.find<ProfileController>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Visibility flags
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Security'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF0D1B2E)],
          ),
        ),
        child: Obx(() {
          return Skeletonizer(
            enabled: controller.isLoading.value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ensure your account is using a long, random password to stay secure.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildLabel('Current Password'),
                  _buildPasswordField(
                    currentPasswordController,
                    _isCurrentPasswordVisible,
                    () => setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildLabel('New Password'),
                  _buildPasswordField(
                    newPasswordController,
                    _isNewPasswordVisible,
                    () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildLabel('Confirm New Password'),
                  _buildPasswordField(
                    confirmPasswordController,
                    _isConfirmPasswordVisible,
                    () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isUpdatingProfile.value
                          ? null
                          : () {
                              if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                Get.snackbar('Error', 'Passwords do not match',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                                return;
                              }
                              controller.changePassword(
                                currentPassword: currentPasswordController.text,
                                newPassword: newPasswordController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isUpdatingProfile.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Update Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController textController,
    bool isVisible,
    VoidCallback onToggle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: textController,
        obscureText: !isVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white38, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: Colors.white38,
              size: 20,
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
