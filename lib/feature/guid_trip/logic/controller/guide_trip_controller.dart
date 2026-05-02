import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/guid_trip/ui/screens/plan_a_trip_details_screen.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideTripController extends GetxController {
  final TripRepo _tripRepo = Get.put(TripRepo());
  final TextEditingController destinationController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final days = <GuideDayModel>[].obs;
  final suggestions = <String>[].obs;
  final isSearching = false.obs;

  final scrollController = ScrollController();
  final isFabVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    destinationController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (destinationController.text.length > 2) {
      searchDestinations(destinationController.text);
    } else {
      suggestions.clear();
    }
  }

  Future<void> searchDestinations(String query) async {
    try {
      isSearching.value = true;
      // Using flight locations endpoint as a proxy for destinations if a general search isn't available
      // or implement a dedicated search call here
      // For now, let's mock the behavior to ensure UI works, then link to real API
      final mockDestinations = ['Cairo', 'Alexandria', 'Luxor', 'Aswan', 'Sharm El Sheikh', 'Hurghada']
          .where((d) => d.toLowerCase().contains(query.toLowerCase()))
          .toList();
      suggestions.assignAll(mockDestinations);
    } finally {
      isSearching.value = false;
    }
  }

  void selectDestination(String dest) {
    destinationController.text = dest;
    suggestions.clear();
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    destinationController.dispose();
    for (var day in days) {
      day.dispose();
    }
    super.onClose();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    update();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    update();
  }

  void updateFabVisibility(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse) {
      if (isFabVisible.value) isFabVisible.value = false;
    } else if (direction == ScrollDirection.forward) {
      if (!isFabVisible.value) isFabVisible.value = true;
    }
  }

  void createGuide() {
    if (destinationController.text.isEmpty || startDate == null || endDate == null) {
      showError('Please fill in all fields');
      return;
    }

    int totalDays = endDate!.difference(startDate!).inDays + 1;
    
    // Dispose old controllers
    for (var day in days) {
      day.dispose();
    }
    days.clear();
    
    for (int i = 0; i < totalDays; i++) {
      days.add(GuideDayModel(dayNumber: i + 1));
    }

    Get.to(() => const PlanATripDetailsScreen());
  }

  void addDay() {
    days.add(GuideDayModel(dayNumber: days.length + 1));
  }

  Future<void> saveTrip() async {
    try {
      // 1. Create the main trip
      final tripToCreate = TripModel(
        id: '', 
        title: 'Manual Trip to ${destinationController.text}',
        description: 'Manually planned trip',
        destination: destinationController.text,
        startDate: startDate?.toIso8601String(),
        endDate: endDate?.toIso8601String(),
        budget: 0,
        status: 'planning',
      );

      final createdTrip = await _tripRepo.createTrip(tripToCreate);

      // 2. Add each day
      for (var day in days) {
        final dayData = {
          'dayNumber': day.dayNumber,
          'date': startDate?.add(Duration(days: day.dayNumber - 1)).toIso8601String(),
          'notes': day.notes.value,
          'activities': [
            {
              'title': day.place.value,
              'time': 'All Day',
              'location': day.address.value,
              'description': day.notes.value,
              'cost': 0,
            }
          ],
        };
        await _tripRepo.addDayToTrip(createdTrip.id, dayData);
      }

      showSuccess('Trip saved successfully!');
    } catch (e) {
      showError('Failed to save trip: $e');
    }
  }

  void shareTrip() {
    if (destinationController.text.isEmpty) return;

    String shareText = 'My Plan for ${destinationController.text} 🇪🇬\n\n';
    
    for (var day in days) {
      shareText += 'Day ${day.dayNumber}:\n';
      shareText += '📍 ${day.place.value}\n';
      if (day.address.value.isNotEmpty) shareText += '🏠 ${day.address.value}\n';
      if (day.notes.value.isNotEmpty) shareText += '📝 ${day.notes.value}\n';
      shareText += '\n';
    }

    shareText += 'Created with EgyTravel App';
    
    // 1. Copy to clipboard
    Clipboard.setData(ClipboardData(text: shareText));
    
    // 2. Show confirmation
    showSuccess('Itinerary copied to clipboard! 📋');

    // 3. Optionally open email/SMS
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
      query: 'subject=My Trip Plan&body=${Uri.encodeComponent(shareText)}',
    );
    launchUrl(emailLaunchUri);
  }
}
