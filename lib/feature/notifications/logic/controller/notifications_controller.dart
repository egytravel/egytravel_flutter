import 'package:egytravel_app/feature/notifications/data/notification_model.dart';
import 'package:get/get.dart';

enum NotificationCategory { all, bookings, updates, promotions }

class NotificationsController extends GetxController {
  final RxList<NotificationModel> _allNotifications = <NotificationModel>[].obs;
  final Rx<NotificationCategory> _selectedCategory =
      NotificationCategory.all.obs;

  List<NotificationModel> get notifications {
    switch (_selectedCategory.value) {
      case NotificationCategory.bookings:
        return _allNotifications
            .where((n) => n.type == NotificationType.booking)
            .toList();
      case NotificationCategory.updates:
        return _allNotifications
            .where((n) => n.type == NotificationType.update)
            .toList();
      case NotificationCategory.promotions:
        return _allNotifications
            .where((n) => n.type == NotificationType.promotion)
            .toList();
      case NotificationCategory.all:
        return _allNotifications;
    }
  }

  NotificationCategory get selectedCategory => _selectedCategory.value;

  int get unreadCount => _allNotifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    _allNotifications.value = [
      NotificationModel(
        id: '1',
        title: 'Flight Booking Confirmed',
        message:
            'Your flight to Cairo has been confirmed. Departure on Jan 28, 2026.',
        type: NotificationType.booking,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Special Offer: 30% Off Hotels',
        message:
            'Book your hotel in Luxor now and save 30%! Limited time offer.',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Trip Update',
        message: 'Your guided tour to the Pyramids starts at 9:00 AM tomorrow.',
        type: NotificationType.update,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Hotel Reservation Confirmed',
        message:
            'Your reservation at Nile Palace Hotel is confirmed. Check-in: Jan 29.',
        type: NotificationType.booking,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Important: Weather Alert',
        message:
            'High temperatures expected in Aswan. Stay hydrated during your visit.',
        type: NotificationType.alert,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '6',
        title: 'New Destinations Available',
        message: 'Explore our newly added destinations in the Red Sea region!',
        type: NotificationType.update,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '7',
        title: 'Early Bird Discount',
        message: 'Book your next adventure 30 days in advance and get 20% off!',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        isRead: true,
      ),
    ];
  }

  void setCategory(NotificationCategory category) {
    _selectedCategory.value = category;
  }

  void markAsRead(String notificationId) {
    final index = _allNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _allNotifications[index] = _allNotifications[index].copyWith(
        isRead: true,
      );
      _allNotifications.refresh();
    }
  }

  void markAllAsRead() {
    _allNotifications.value = _allNotifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
  }

  void deleteNotification(String notificationId) {
    _allNotifications.removeWhere((n) => n.id == notificationId);
  }
}
