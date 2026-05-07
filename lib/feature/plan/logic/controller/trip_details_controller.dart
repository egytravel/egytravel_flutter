import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/booking/data/repo/booking_repo.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:get/get.dart';

class TripDetailsController extends GetxController {
  final TripRepo _tripRepo = TripRepo();
  final BookingRepo _bookingRepo = BookingRepo();
  final String tripId;

  TripDetailsController(this.tripId);

  final Rxn<TripModel> trip = Rxn<TripModel>();
  final RxList<TripDayModel> days = <TripDayModel>[].obs;
  final RxList<TripBookingModel> bookings = <TripBookingModel>[].obs;
  final RxList<TripMapMarker> mapMarkers = <TripMapMarker>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isDaysLoading = false.obs;
  final RxBool isMapLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTripDetails();
  }

  Future<void> deleteTrip() async {
    try {
      await _tripRepo.deleteTrip(tripId);
      showSuccess('Trip deleted');
      Get.back();
    } catch (_) {
      showError('Failed to delete trip');
    }
  }

  Future<bool> fetchTripDetails({
    bool showLoader = true,
    bool preserveStateOnError = false,
    bool showSnackbarOnError = true,
  }) async {
    try {
      if (showLoader) {
        isLoading.value = true;
      }

      if (!preserveStateOnError) {
        hasError.value = false;
      }
      errorMessage.value = '';

      final data = await _tripRepo.getTripDetails(tripId);
      trip.value = data;
      bookings.assignAll(data.bookings ?? <TripBookingModel>[]);

      if (data.days != null) {
        days.assignAll(data.days!);
      } else {
        final loadedDays = await _loadDaysFallback();
        if (!loadedDays && !preserveStateOnError) {
          days.clear();
        }
      }

      hasError.value = false;
      fetchMapMarkers();
      return true;
    } catch (error) {
      errorMessage.value = _readableError(error);
      if (!preserveStateOnError || trip.value == null) {
        hasError.value = true;
      }

      if (showSnackbarOnError) {
        showError(
          trip.value == null
              ? 'Failed to load trip details'
              : 'Failed to refresh trip details',
        );
      }
      return false;
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateTrip(Map<String, dynamic> updates) async {
    try {
      isSaving.value = true;
      await _tripRepo.updateTrip(tripId, updates);
      await _refreshAfterMutation(
        successMessage: 'Trip updated!',
        warningMessage:
            'Trip updated, but latest details could not be refreshed.',
      );
    } catch (_) {
      showError('Failed to update trip');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> fetchDays() async {
    try {
      isDaysLoading.value = true;
      final fetchedDays = await _tripRepo.getTripDays(tripId);
      days.assignAll(fetchedDays);
    } catch (_) {
      // Days may not exist yet.
    } finally {
      isDaysLoading.value = false;
    }
  }

  Future<TripDayModel?> addDay(Map<String, dynamic> dayData) async {
    try {
      isSaving.value = true;
      final newDay = await _tripRepo.addDayToTrip(tripId, dayData);
      days.add(newDay);
      await _refreshAfterMutation(
        successMessage: 'Day added!',
        warningMessage: 'Day added, but latest details could not be refreshed.',
      );
      return newDay;
    } catch (_) {
      showError('Failed to add day');
      return null;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateDay(String dayId, Map<String, dynamic> dayData) async {
    try {
      isSaving.value = true;
      final updated = await _tripRepo.updateDay(tripId, dayId, dayData);
      final index = days.indexWhere((day) => day.id == dayId);
      if (index != -1) {
        days[index] = updated;
        days.refresh();
      }
      await _refreshAfterMutation(
        successMessage: 'Day updated!',
        warningMessage:
            'Day updated, but latest details could not be refreshed.',
      );
    } catch (_) {
      showError('Failed to update day');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteDay(String dayId) async {
    try {
      isSaving.value = true;
      await _tripRepo.deleteDay(tripId, dayId);
      days.removeWhere((day) => day.id == dayId);
      await _refreshAfterMutation(
        successMessage: 'Day removed',
        warningMessage:
            'Day deleted, but latest details could not be refreshed.',
      );
    } catch (_) {
      showError('Failed to delete day');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateDayActivities(
    String dayId,
    List<TripActivityModel> activities,
  ) async {
    final dayData = {
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
    await updateDay(dayId, dayData);
  }

  Future<void> attachHotel(Map<String, dynamic> hotelData) async {
    try {
      isSaving.value = true;
      await _bookingRepo.createHotelBooking({'tripId': tripId, ...hotelData});
      await _refreshAfterMutation(
        successMessage: 'Hotel booking added!',
        warningMessage:
            'Hotel booking added, but latest details could not be refreshed.',
      );
    } catch (_) {
      showError('Failed to attach hotel booking');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> fetchMapMarkers() async {
    try {
      isMapLoading.value = true;
      final markers = await _tripRepo.getTripMapMarkers(tripId);
      mapMarkers.assignAll(markers);
    } catch (_) {
      // Map data may not exist yet.
    } finally {
      isMapLoading.value = false;
    }
  }

  Future<bool> _loadDaysFallback() async {
    try {
      isDaysLoading.value = true;
      final fetchedDays = await _tripRepo.getTripDays(tripId);
      days.assignAll(fetchedDays);
      return true;
    } catch (_) {
      return false;
    } finally {
      isDaysLoading.value = false;
    }
  }

  Future<void> _refreshAfterMutation({
    required String successMessage,
    required String warningMessage,
  }) async {
    final refreshed = await fetchTripDetails(
      showLoader: false,
      preserveStateOnError: true,
      showSnackbarOnError: false,
    );

    if (refreshed) {
      showSuccess(successMessage);
    } else {
      showError(warningMessage);
    }
  }

  String _readableError(Object error) {
    return error.toString().replaceAll('Exception: ', '').trim();
  }
}
