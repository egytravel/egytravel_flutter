import 'dart:ui';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/notifications/logic/controller/notifications_controller.dart';
import 'package:egytravel_app/feature/notifications/ui/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          actions: [
            Obx(() {
              final hasUnread = controller.unreadCount > 0;
              return TextButton(
                onPressed: hasUnread ? controller.markAllAsRead : null,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: hasUnread
                        ? AppColor.primaryColor
                        : Colors.white.withOpacity(0.3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Category Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Obx(
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildCategoryButton(
                            controller,
                            NotificationCategory.all,
                            'All',
                          ),
                          const SizedBox(width: 6),
                          _buildCategoryButton(
                            controller,
                            NotificationCategory.bookings,
                            'Bookings',
                          ),
                          const SizedBox(width: 6),
                          _buildCategoryButton(
                            controller,
                            NotificationCategory.updates,
                            'Updates',
                          ),
                          const SizedBox(width: 6),
                          _buildCategoryButton(
                            controller,
                            NotificationCategory.promotions,
                            'Offers',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Notifications List
            Expanded(
              child: Obx(() {
                final notifications = controller.notifications;

                if (notifications.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(notification: notifications[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    NotificationsController controller,
    NotificationCategory category,
    String label,
  ) {
    final isSelected = controller.selectedCategory == category;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setCategory(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
