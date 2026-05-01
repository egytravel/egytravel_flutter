import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:egytravel_app/core/models/trip_model.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/suggested_plan_screen.dart';
import 'package:egytravel_app/feature/profile/data/model/profile_model.dart';
import 'package:egytravel_app/feature/profile/data/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileRepo _repo = ProfileRepo();

  // ── Scroll ──────────────────────────────────────────────────────────────
  final scrollController = ScrollController();
  final isScrolled = false.obs;

  // ── Profile ──────────────────────────────────────────────────────────────
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final isLoading = true.obs;
  final isUpdatingProfile = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // ── Notifications ────────────────────────────────────────────────────────
  final pushEnabled = true.obs;
  final emailEnabled = true.obs;
  final isUpdatingNotif = false.obs;

  // ── Trips (local mock until trips API is connected) ──────────────────────
  final RxList<Trip> userTrips = <Trip>[].obs;

  // ── Favorites, Bookings, Travel History ──────────────────────────────────
  final favorites = <Map<String, dynamic>>[].obs;
  final isLoadingFavorites = false.obs;

  final bookings = <Map<String, dynamic>>[].obs;
  final isLoadingBookings = false.obs;

  final travelHistory = <Map<String, dynamic>>[].obs;
  final isLoadingHistory = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchProfile();
    fetchNotifications();
    fetchTrips();
  }

  // ── Scroll listener ──────────────────────────────────────────────────────
  void _scrollListener() {
    final offset = scrollController.offset;
    if (offset > 200 && !isScrolled.value) {
      isScrolled.value = true;
    } else if (offset <= 200 && isScrolled.value) {
      isScrolled.value = false;
    }
  }

  // ── GET profile ──────────────────────────────────────────────────────────
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      profile.value = await _repo.getProfile();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ── PUT profile ──────────────────────────────────────────────────────────
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? nationality,
    String? dateOfBirth,
    String? profilePhotoUrl,
  }) async {
    try {
      isUpdatingProfile.value = true;
      profile.value = await _repo.updateProfile(
        name: name,
        phone: phone,
        nationality: nationality,
        dateOfBirth: dateOfBirth,
        profilePhotoUrl: profilePhotoUrl,
      );
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 1), () => Get.back());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // ── PUT change password ──────────────────────────────────────────────────
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isUpdatingProfile.value = true;
      await _repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      Get.snackbar(
        'Success',
        'Password changed successfully',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 1), () => Get.back());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // ── GET notifications ────────────────────────────────────────────────────
  Future<void> fetchNotifications() async {
    try {
      final prefs = await _repo.getNotifications();
      pushEnabled.value = prefs['push_enabled'] ?? true;
      emailEnabled.value = prefs['email_enabled'] ?? true;
    } catch (_) {
      // keep defaults if fails
    }
  }

  // ── PUT notifications ────────────────────────────────────────────────────
  Future<void> togglePushNotification(bool value) async {
    pushEnabled.value = value;
    try {
      isUpdatingNotif.value = true;
      await _repo.updateNotifications(
        pushEnabled: value,
        emailEnabled: emailEnabled.value,
      );
    } catch (_) {
      pushEnabled.value = !value; // revert on error
    } finally {
      isUpdatingNotif.value = false;
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await SharedPreferencesHelper.clearToken();
      profile.value = null;
      Get.offAllNamed('/splash_screen');
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout');
    }
  }

  // ── DELETE account ────────────────────────────────────────────────────────
  Future<void> deleteAccount(String password) async {
    try {
      await _repo.deleteAccount(password: password);
      Get.offAllNamed('/splash_screen');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ── Favorites ────────────────────────────────────────────────────────────
  Future<void> fetchFavorites() async {
    try {
      isLoadingFavorites.value = true;
      favorites.value = await _repo.getMyFavorites();
    } catch (_) {
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  // ── Bookings ─────────────────────────────────────────────────────────────
  Future<void> fetchBookings() async {
    try {
      isLoadingBookings.value = true;
      bookings.value = await _repo.getMyBookings();
    } catch (_) {
    } finally {
      isLoadingBookings.value = false;
    }
  }

  // ── Travel History ────────────────────────────────────────────────────────
  Future<void> fetchTravelHistory() async {
    try {
      isLoadingHistory.value = true;
      travelHistory.value = await _repo.getTravelHistory();
    } catch (_) {
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // ── Trips ────────────────────────────────────────────────────────────────
  Future<void> fetchTrips() async {
    try {
      final tripsData = await _repo.getMyTrips();
      userTrips.value = tripsData.map((t) => Trip.fromJson(t)).toList();
    } catch (_) {
      // keep empty or previous trips
    }
  }

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
