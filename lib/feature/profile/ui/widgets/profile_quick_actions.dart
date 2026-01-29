import 'dart:ui';
import 'package:flutter/material.dart';

class ProfileQuickActions extends StatelessWidget {
  const ProfileQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: _buildQuickActionCard(
                  Icons.edit_outlined,
                  'Edit Profile',
                  Colors.white,
                  () {},
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: _buildQuickActionCard(
                  Icons.share_outlined,
                  'Share',
                  Colors.white,
                  () {},
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: _buildQuickActionCard(
                  Icons.wallet_outlined,
                  'Wallet',
                  Colors.white,
                  () {},
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: _buildQuickActionCard(
                  Icons.support_agent_outlined,
                  'Support',
                  Colors.white,
                  () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(
    IconData icon,
    String label,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
