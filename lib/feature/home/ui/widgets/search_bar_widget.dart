import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:get/get.dart';
import 'dart:ui';

class SearchBarWidget extends StatelessWidget {
  final HomeController controller;

  const SearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: GestureDetector(
        onTap: () {
          // Navigate to search screen
          Get.toNamed(Routes.search);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColor.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Search destinations...',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColor.primaryColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
