import 'package:egytravel_app/core/models/trip_model.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/suggested_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final scrollController = ScrollController();
  final isScrolled = false.obs;
  final scrollOpacity = 0.0.obs;

  // Trips management
  final RxList<Trip> userTrips = <Trip>[].obs;
  final isLoadingTrips = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    loadUserTrips();
  }

  void _scrollListener() {
    // Calculate opacity based on scroll position (0-200 pixels)
    final offset = scrollController.offset;
    scrollOpacity.value = (offset / 200).clamp(0.0, 1.0);

    if (offset > 200 && !isScrolled.value) {
      isScrolled.value = true;
    } else if (offset <= 200 && isScrolled.value) {
      isScrolled.value = false;
    }
  }

  // Load user trips
  void loadUserTrips() {
    isLoadingTrips.value = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      userTrips.value = Trip.getMockTrips();
      isLoadingTrips.value = false;
    });
  }

  // Navigate to trip details
  void navigateToTripDetails(Trip trip) {
    Get.to(
      () => TripItineraryScreen(
        destination: trip.destination,
        startDate: trip.startDate,
        endDate: trip.endDate,
        budget: trip.budget,
        interests: trip.interests,
      ),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
