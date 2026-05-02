import 'package:egytravel_app/feature/wallet/ui/screens/wallet_screen.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileQuickActions extends StatelessWidget {
  const ProfileQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildAction(
            icon: Icons.wallet_outlined,
            label: 'Wallet',
            onTap: () => Get.to(() => const WalletScreen()),
          ),
          const SizedBox(width: 10),
          _buildAction(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () {
              Get.snackbar('Share', 'Sharing functionality coming soon!',
                  backgroundColor: Colors.white10, colorText: Colors.white);
            },
          ),
          const SizedBox(width: 10),
          _buildAction(
            icon: Icons.feedback_outlined,
            label: 'Feedback',
            onTap: () {
              _showFeedbackDialog(context);
            },
          ),
          const SizedBox(width: 10),
          _buildAction(
            icon: Icons.support_agent_outlined,
            label: 'Support',
            onTap: () {
              Get.snackbar('Support', 'Connecting to support...',
                  backgroundColor: Colors.white10, colorText: Colors.white);
            },
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    BetterFeedback.of(context).show((UserFeedback feedback) {
      // Do something with the feedback
      // e.g. upload it to your server
      Get.snackbar(
        'Thank You!',
        'Your feedback and screenshot have been submitted.',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
    });
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white70, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
