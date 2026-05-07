import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:egytravel_app/feature/guid_trip/ui/screens/plan_a_trip_details_screen.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:egytravel_app/feature/plan/ui/screen/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideTripController extends GetxController {
  final TripRepo _tripRepo = TripRepo();

  final TextEditingController destinationController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final RxList<GuideDayModel> days = <GuideDayModel>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;
  final Rxn<TripModel> trip = Rxn<TripModel>();
  final RxString errorMessage = ''.obs;

  final ScrollController scrollController = ScrollController();
  final RxBool isFabVisible = true.obs;

  String? _createdTripId;

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
      final mockDestinations =
          [
            'Cairo',
            'Alexandria',
            'Luxor',
            'Aswan',
            'Sharm El Sheikh',
            'Hurghada',
          ].where((destination) {
            return destination.toLowerCase().contains(query.toLowerCase());
          }).toList();
      suggestions.assignAll(mockDestinations);
    } finally {
      isSearching.value = false;
    }
  }

  void selectDestination(String destination) {
    destinationController.text = destination;
    suggestions.clear();
    update();
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

  Future<void> createGuide() async {
    if (!_validateBaseTripInputs()) return;

    final totalDays = endDate!.difference(startDate!).inDays + 1;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdTrip = await _tripRepo.createTrip(_buildBaseTrip());
      final tripId = createdTrip.id.trim();

      if (tripId.isEmpty) {
        throw Exception('Trip created but no trip id was returned.');
      }

      _createdTripId = tripId;
      trip.value = createdTrip;

      final refreshed = await _refreshTrip(tripId);
      _rebuildDays(totalDays);

      if (refreshed) {
        showSuccess('Trip created successfully!');
      } else {
        showError(
          'Trip created, but latest details could not be refreshed. You can continue editing.',
        );
      }

      Get.to(() => const PlanATripDetailsScreen());
    } catch (error) {
      final message = _readableError(error);
      errorMessage.value = message;
      showError('Failed to create trip: $message');
    } finally {
      isLoading.value = false;
    }
  }

  void addDay() {
    days.add(GuideDayModel(dayNumber: days.length + 1));
  }

  Future<void> saveTrip() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      String tripId = (_createdTripId ?? '').trim();
      if (tripId.isEmpty) {
        final createdTrip = await _tripRepo.createTrip(_buildBaseTrip());
        tripId = createdTrip.id.trim();
        if (tripId.isEmpty) {
          throw Exception('Trip created but no trip id was returned.');
        }
        _createdTripId = tripId;
        trip.value = createdTrip;
      }

      for (final day in days) {
        final dayDate = startDate?.add(Duration(days: day.dayNumber - 1));
        final dayData = <String, dynamic>{
          'dayNumber': day.dayNumber,
          if (dayDate != null) 'date': _formatDate(dayDate),
          if (day.place.value.isNotEmpty) 'title': day.place.value,
          if (day.notes.value.isNotEmpty) 'notes': day.notes.value,
          'activities': [
            {
              'title': day.place.value.isNotEmpty
                  ? day.place.value
                  : 'Activity',
              'time': 'All Day',
              if (day.address.value.isNotEmpty) 'location': day.address.value,
              if (day.notes.value.isNotEmpty) 'description': day.notes.value,
            },
          ],
        };

        await _tripRepo.addDayToTrip(tripId, dayData);
      }

      final refreshed = await _refreshTrip(tripId);
      if (refreshed) {
        showSuccess('Trip saved successfully!');
      } else {
        showError('Trip saved, but latest details could not be refreshed.');
      }

      Get.off(
        () => TripDetailsScreen(tripId: tripId),
        transition: Transition.cupertino,
      );
    } catch (error) {
      final message = _readableError(error);
      errorMessage.value = message;
      showError('Failed to save trip: $message');
    } finally {
      isLoading.value = false;
    }
  }

  void shareTrip() {
    if (destinationController.text.isEmpty) return;

    final buffer = StringBuffer(
      'My Plan for ${destinationController.text}\n\n',
    );

    for (final day in days) {
      buffer.writeln('Day ${day.dayNumber}:');
      if (day.place.value.isNotEmpty) {
        buffer.writeln('Title: ${day.place.value}');
      }
      if (day.address.value.isNotEmpty) {
        buffer.writeln('Place: ${day.address.value}');
      }
      if (day.notes.value.isNotEmpty) {
        buffer.writeln('Notes: ${day.notes.value}');
      }
      buffer.writeln();
    }

    buffer.write('Created with EgyTravel App');
    final shareText = buffer.toString();

    Clipboard.setData(ClipboardData(text: shareText));
    showSuccess('Itinerary copied to clipboard!');

    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
      query: 'subject=My Trip Plan&body=${Uri.encodeComponent(shareText)}',
    );
    launchUrl(emailLaunchUri);
  }

  bool _validateBaseTripInputs() {
    if (destinationController.text.trim().isEmpty ||
        startDate == null ||
        endDate == null) {
      errorMessage.value = 'Please fill in all fields';
      showError(errorMessage.value);
      return false;
    }
    return true;
  }

  TripModel _buildBaseTrip() {
    final destination = destinationController.text.trim();
    return TripModel(
      id: '',
      title: 'Trip to $destination',
      description: 'Planned trip to $destination',
      destination: destination,
      startDate: startDate != null ? _formatDate(startDate!) : null,
      endDate: endDate != null ? _formatDate(endDate!) : null,
      budget: 0,
      status: 'planning',
    );
  }

  Future<bool> _refreshTrip(String tripId) async {
    try {
      final refreshedTrip = await _tripRepo.getTripDetails(tripId);
      trip.value = refreshedTrip;
      errorMessage.value = '';
      return true;
    } catch (error) {
      errorMessage.value = _readableError(error);
      return false;
    }
  }

  void _rebuildDays(int totalDays) {
    // Clear the list first to notify observers (UI) to stop using these models
    final oldDays = List<GuideDayModel>.from(days);
    days.clear();
    
    // Now safely dispose old controllers
    for (final day in oldDays) {
      day.dispose();
    }

    for (int index = 0; index < totalDays; index++) {
      days.add(GuideDayModel(dayNumber: index + 1));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _readableError(Object error) {
    return error.toString().replaceAll('Exception: ', '').trim();
  }

  @override
  void onClose() {
    destinationController.removeListener(_onSearchChanged);
    
    final oldDays = List<GuideDayModel>.from(days);
    days.clear();
    for (final day in oldDays) {
      day.dispose();
    }

    scrollController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}
