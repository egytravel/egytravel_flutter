import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/suggested_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  final TripRepo _tripRepo = TripRepo();
  final TextEditingController destinationController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String? selectedBudget;
  List<String> selectedInterests = [];

  final isLoading = false.obs;

  // ======== SETTERS =========

  void setStartDate(DateTime? date) {
    startDate = date;
    update();
  }

  void setEndDate(DateTime? date) {
    endDate = date;
    update();
  }

  void setDates(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    update();
  }

  void setBudget(String budget) {
    selectedBudget = budget;
    update();
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    update();
  }

  // ======== HELPERS =========

  /// Converts the budget label ('Budget', 'Medium', 'Luxury') to a numeric value.
  double _budgetToNumber(String? budgetLabel) {
    switch (budgetLabel) {
      case 'Budget':
        return 500;
      case 'Medium':
        return 1500;
      case 'Luxury':
        return 3000;
      default:
        return 1000;
    }
  }

  /// Formats DateTime as yyyy-MM-dd (API expected format).
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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

  // ======== CREATE TRIP & NAVIGATE =========

  /// Creates a trip via API, then navigates to the itinerary screen.
  Future<void> createAndNavigate(BuildContext context) async {
    if (!validateInputs(context)) return;

    try {
      isLoading.value = true;

      final destination = destinationController.text.trim();
      final budgetValue = _budgetToNumber(selectedBudget);

      // Build the trip payload matching the API schema:
      // {
      //   "title": "My Egypt Adventure",
      //   "description": "Exploring ancient wonders and modern Cairo",
      //   "destination": "Cairo, Egypt",
      //   "startDate": "2026-07-01",
      //   "endDate": "2026-07-07",
      //   "budget": 2000
      // }
      final tripToCreate = TripModel(
        id: '',
        title: 'Trip to $destination',
        description: 'A $selectedBudget trip to $destination',
        destination: destination,
        startDate: _formatDate(startDate!),
        endDate: _formatDate(endDate!),
        budget: budgetValue,
        status: 'planning',
      );

      // Log the request body
      debugPrint('══════════════════════════════════════════');
      debugPrint('📤 CREATE TRIP REQUEST:');
      debugPrint('   Body: ${tripToCreate.toJson()}');
      debugPrint('══════════════════════════════════════════');

      final createdTrip = await _tripRepo.createTrip(tripToCreate);

      // Log the response
      debugPrint('══════════════════════════════════════════');
      debugPrint('✅ CREATE TRIP RESPONSE:');
      debugPrint('   Trip ID: ${createdTrip.id}');
      debugPrint('   Title: ${createdTrip.title}');
      debugPrint('   Destination: ${createdTrip.destination}');
      debugPrint('   Start: ${createdTrip.startDate}');
      debugPrint('   End: ${createdTrip.endDate}');
      debugPrint('   Budget: ${createdTrip.budget}');
      debugPrint('   Status: ${createdTrip.status}');
      debugPrint('══════════════════════════════════════════');

      showSuccess('Trip created successfully!');

      // Navigate to itinerary screen with real trip data
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripItineraryScreen(
              destination: destination,
              startDate: startDate!,
              endDate: endDate!,
              budget: selectedBudget!,
              interests: selectedInterests,
              tripId: createdTrip.id,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('══════════════════════════════════════════');
      debugPrint('❌ CREATE TRIP FAILED: $e');
      debugPrint('══════════════════════════════════════════');
      showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Fallback navigation without API (for offline / AI-generated plans)
  void navigateToTripScreen(BuildContext context) {
    if (!validateInputs(context)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripItineraryScreen(
          destination: destinationController.text.trim(),
          startDate: startDate!,
          endDate: endDate!,
          budget: selectedBudget!,
          interests: selectedInterests,
          tripId: '',
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
    update();
  }

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }
}
