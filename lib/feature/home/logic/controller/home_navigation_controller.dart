import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  static HomeNavigationController get instance => Get.find();

  final selectedBottomTab = 0.obs;
  final selectedBookingTab = 0.obs; // 0 for Flights, 1 for Hotels

  void navigateToBookingTab({int bookingTabIndex = 0}) {
    selectedBookingTab.value = bookingTabIndex;
    selectedBottomTab.value = 3; // Index of booking tab in bottom nav
  }

  void setBottomTab(int index) {
    selectedBottomTab.value = index;
  }
}
