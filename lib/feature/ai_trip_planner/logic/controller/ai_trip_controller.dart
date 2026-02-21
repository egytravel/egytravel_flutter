import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/suggested_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  final TextEditingController destinationController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String? selectedBudget;
  List<String> selectedInterests = [];

  // ======== SETTERS =========

  void setStartDate(DateTime? date) {
    startDate = date;
    update(); // UI UPDATE
  }

  void setEndDate(DateTime? date) {
    endDate = date;
    update(); // UI UPDATE
  }

  void setDates(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    update(); // UI UPDATE
  }

  void setBudget(String budget) {
    selectedBudget = budget;
    update(); // UI UPDATE
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    update(); // UI UPDATE
  }

  // ======== VALIDATION =========

  bool validateInputs(BuildContext context) {
    if (destinationController.text.isEmpty) {
      _showSnackBar(context, 'Please enter a destination');
      return false;
    }
    if (startDate == null || endDate == null) {
      _showSnackBar(context, 'Please select travel dates');
      return false;
    }
    if (selectedBudget == null) {
      _showSnackBar(context, 'Please select your budget');
      return false;
    }
    return true;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ======== NAVIGATION =========

  void navigateToTripScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripItineraryScreen(
          destination: destinationController.text,
          startDate: startDate!,
          endDate: endDate!,
          budget: selectedBudget!,
          interests: selectedInterests,
        ),
      ),
    );
  }

  // ======== CLEAR FORM =========

  void clearAll() {
    destinationController.clear();
    startDate = null;
    endDate = null;
    selectedBudget = null;
    selectedInterests.clear();
    update(); // UI UPDATE
  }

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }
}
