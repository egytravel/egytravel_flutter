import 'dart:ui';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/notifications/data/notification_model.dart';
import 'package:egytravel_app/feature/notifications/logic/controller/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteNotification(notification.id);
        Get.snackbar(
          'Deleted',
          'Notification removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.red.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: notification.isRead
                        ? Colors.white.withOpacity(0.1)
                        : AppColor.primaryColor.withOpacity(0.5),
                    width: notification.isRead ? 1 : 2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getIconBackgroundColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(),
                        color: _getIconColor(),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: notification.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColor.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notification.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            timeago.format(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
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

  IconData _getIconData() {
    switch (notification.type) {
      case NotificationType.booking:
        return Icons.confirmation_number_outlined;
      case NotificationType.update:
        return Icons.info_outline;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.alert:
        return Icons.warning_amber_outlined;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.booking:
        return AppColor.primaryColor;
      case NotificationType.update:
        return Colors.blue;
      case NotificationType.promotion:
        return Colors.green;
      case NotificationType.alert:
        return Colors.orange;
    }
  }

  Color _getIconBackgroundColor() {
    switch (notification.type) {
      case NotificationType.booking:
        return AppColor.primaryColor.withOpacity(0.15);
      case NotificationType.update:
        return Colors.blue.withOpacity(0.15);
      case NotificationType.promotion:
        return Colors.green.withOpacity(0.15);
      case NotificationType.alert:
        return Colors.orange.withOpacity(0.15);
    }
  }
}
