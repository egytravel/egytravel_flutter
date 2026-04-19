import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/notifications/logic/controller/notifications_controller.dart';
import 'package:egytravel_app/feature/notifications/ui/screen/notifications_screen.dart';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;

  const HomeAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Initialize controller to track unread count
    final notificationsController = Get.put(NotificationsController());

    return Obx(() {
      final isScrolled = controller.isScrolled.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isScrolled ? 15 : 0,
              sigmaY: isScrolled ? 15 : 0,
            ),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: isScrolled
                  ? const Color(0xFF0A1628).withOpacity(0.95)
                  : Colors.transparent,
              elevation: 0,
              actions: [
                /// Community Feed Icon
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Get.toNamed(Routes.community),
                    icon: const Icon(
                      Icons.groups_outlined,
                      color: Color(0xFF2D3748),
                    ),
                    tooltip: 'Community',
                  ),
                ),

                /// Notifications Icon
                Container(
                  margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => const NotificationsScreen(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      // Unread badge
                      Obx(() {
                        final unreadCount = notificationsController.unreadCount;
                        if (unreadCount == 0) return const SizedBox.shrink();

                        return Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount > 9 ? '9+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
