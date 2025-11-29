import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class ViewerBottomBar extends StatelessWidget {
  final VoidCallback onInfoTap;

  const ViewerBottomBar({super.key, required this.onInfoTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.download_rounded,
              label: 'Download',
              onTap: () {
                Get.snackbar(
                  'Download',
                  'Image downloaded successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  barBlur: 10,
                  overlayBlur: 2,
                );
              },
            ),
            _buildActionButton(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: () {
                Get.snackbar(
                  'Share',
                  'Sharing image...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  barBlur: 10,
                  overlayBlur: 2,
                );
              },
            ),
            _buildActionButton(
              icon: Icons.info_outline_rounded,
              label: 'Info',
              onTap: onInfoTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
