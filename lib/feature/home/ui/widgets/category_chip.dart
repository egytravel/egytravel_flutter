import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:get/get.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final HomeController controller;

  const CategoryChip({
    super.key,
    required this.category,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == category;

      return GestureDetector(
        onTap: () => controller.selectedCategory.value = category,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFFFF6B35).withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 12 : 8,
                offset: Offset(0, isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                controller.getCategoryIcon(category),
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
