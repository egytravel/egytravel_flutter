import 'dart:async';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/ai_trip_planner/data/models/trip_plan_model.dart';
import 'package:egytravel_app/feature/ai_trip_planner/data/repo/ai_trip_repo.dart';
import 'package:egytravel_app/feature/home/data/model/destination_model.dart';
import 'package:egytravel_app/feature/home/data/repo/home_repo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:geolocator/geolocator.dart';

class TripController extends GetxController with StateMixin<TripPlanModel> {
  final AiTripRepository _repository;
  final HomeRepo _homeRepo = HomeRepo();
  TripController(this._repository);

  // Input states
  final TextEditingController cityController = TextEditingController();
  final RxList<Destination> suggestions = <Destination>[].obs;
  final RxBool isSearching = false.obs;
  
  final RxList<String> selectedInterests = <String>[].obs;
  final RxString selectedBudget = 'medium'.obs;
  final RxInt selectedDays = 3.obs;
  final RxInt selectedDayIndex = 0.obs;
  final RxString selectedCity = ''.obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Timer? _debounce;

  // Options
  final List<String> availableInterests = [
    'Pyramids & Pharaonic',
    'Museums',
    'Nightlife & Lounges',
    'Nature & Parks',
    'Marina & Sea',
    'Beaches',
    'Snorkeling & Diving',
    'Nile Cruises',
    'Safari',
    'Theme Parks',
  ];

  final List<String> availableBudgets = ['low', 'medium', 'high'];

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.empty());
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      suggestions.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final allResults = await _homeRepo.searchDestinations(query);
        
        // Filter locally to ensure only matches are shown
        final results = allResults.where((dest) => 
            dest.name.toLowerCase().contains(query.toLowerCase())).toList();
        
        // Sort results by relevance (prefix match first)
        results.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();
          final q = query.toLowerCase();
          
          final aStarts = aName.startsWith(q);
          final bStarts = bName.startsWith(q);
          
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          return aName.compareTo(bName);
        });
        
        suggestions.assignAll(results);
      } catch (e) {
        print('Error searching provinces: $e');
      } finally {
        isSearching.value = false;
      }
    });
  }

  void onDateRangeSelected(PickerDateRange range) {
    startDate.value = range.startDate;
    endDate.value = range.endDate;
    _calculateDays();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      startDate.value = picked;
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
      _calculateDays();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (startDate.value == null) {
      Get.snackbar('Selection Required', 'Please select a start date first');
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? startDate.value!.add(const Duration(days: 1)),
      firstDate: startDate.value!,
      lastDate: startDate.value!.add(const Duration(days: 30)),
    );
    if (picked != null) {
      endDate.value = picked;
      _calculateDays();
    }
  }

  void _calculateDays() {
    if (startDate.value != null && endDate.value != null) {
      selectedDays.value = endDate.value!.difference(startDate.value!).inDays + 1;
    }
  }

  void selectProvince(Destination destination) {
    selectedCity.value = destination.name;
    cityController.text = destination.name;
    suggestions.clear();
  }

  Future<void> generateTrip() async {
    if (selectedCity.isEmpty) {
      Get.snackbar('Selection Required', 'Please select a destination');
      return;
    }

    if (startDate.value == null || endDate.value == null) {
      Get.snackbar('Selection Required', 'Please select start and end dates');
      return;
    }
    
    if (selectedInterests.isEmpty) {
      Get.snackbar(
        'Selection Required',
        'Please select at least one interest to help us plan your trip',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    change(null, status: RxStatus.loading());

    try {
      double? lat;
      double? lon;

      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        lat = position.latitude;
        lon = position.longitude;
      } catch (e) {
        print("Could not get location for trip: $e");
      }

      final trip = await _repository.generateTrip(
        city: selectedCity.value,
        days: selectedDays.value,
        interests: selectedInterests.toList(),
        budget: selectedBudget.value,
        startDate: startDate.value!,
        endDate: endDate.value!,
        lat: lat,
        lon: lon,
      );
      
      if (trip.data.days.isEmpty) {
        change(trip, status: RxStatus.empty());
      } else {
        change(trip, status: RxStatus.success());
        Get.toNamed(Routes.aiTripResult);
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void updateBudget(String budget) {
    selectedBudget.value = budget;
  }

  void updateDays(int days) {
    selectedDays.value = days;
  }

  void clearTrip() {
    change(null, status: RxStatus.empty());
    cityController.clear();
    selectedCity.value = '';
    selectedInterests.clear();
  }

  @override
  void onClose() {
    cityController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
