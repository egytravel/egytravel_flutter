import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:egytravel_app/feature/guid_trip/ui/screens/guide_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideTripController extends GetxController {
  final TextEditingController destinationController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final days = <GuideDayModel>[].obs;

  void setStartDate(DateTime date) {
    startDate = date;
    update();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    update();
  }

  void createGuide() {
    if (destinationController.text.isEmpty || startDate == null || endDate == null) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    int totalDays = endDate!.difference(startDate!).inDays + 1;
    days.clear();
    for (int i = 0; i < totalDays; i++) {
      days.add(GuideDayModel(dayNumber: i + 1));
    }

    Get.to(() => const GuideDetailsScreen());
  }

  void addDay() {
    days.add(GuideDayModel(dayNumber: days.length + 1));
  }
}
