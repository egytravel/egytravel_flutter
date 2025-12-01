import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../logic/controller/saint_moritz_controller.dart';

class DetailTabBar extends StatelessWidget {
  final SaintMoritzController controller;

  const DetailTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              _buildTab('Descriptions', 0),
              _buildTab('Photos', 1),
              _buildTab('Reviews', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTab.value == index;
        return GestureDetector(
          onTap: () => controller.changeTab(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ),
        );
      }),
    );
  }
}
