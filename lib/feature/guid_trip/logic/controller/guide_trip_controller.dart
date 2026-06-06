import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/booking/data/models/flight_model.dart';
import 'package:egytravel_app/feature/booking/data/models/hotel_model.dart';
import 'package:egytravel_app/feature/explore/data/repo/explore_repo.dart';
import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:egytravel_app/feature/guid_trip/ui/screens/plan_a_trip_details_screen.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:egytravel_app/feature/plan/logic/controller/saved_trips_controller.dart';
import 'package:egytravel_app/feature/plan/ui/screen/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideTripController extends GetxController {
  final TripRepo _tripRepo = TripRepo();
  final ExploreRepo _exploreRepo = ExploreRepo();

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final RxList<GuideDayModel> days = <GuideDayModel>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;
  final Rxn<TripModel> trip = Rxn<TripModel>();
  final RxString errorMessage = ''.obs;

  // ── HOTELS ────────────────────────────────────────────────────────────────
  final RxList<HotelModel> hotelResults = <HotelModel>[].obs;
  final RxBool isSearchingHotels = false.obs;

  // ── FLIGHTS ───────────────────────────────────────────────────────────────
  final RxList<FlightModel> flightResults = <FlightModel>[].obs;
  final RxBool isSearchingFlights = false.obs;

  final ScrollController scrollController = ScrollController();
  final RxBool isFabVisible = true.obs;

  String? _createdTripId;
  String? get createdTripId => _createdTripId;

  // ── MAP ────────────────────────────────────────────────────────────────────
  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<LatLng> mapCenter = const LatLng(26.8206, 30.8025).obs; // Egypt center

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
      final results = await _tripRepo.searchPlaces(query);
      final names = results
          .map((r) =>
              (r['name'] ?? r['title'] ?? r['placeName'] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .toList();
      suggestions.assignAll(names);
    } catch (_) {
      suggestions.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void selectDestination(String destination) {
    destinationController.text = destination;
    suggestions.clear();
    update();
  }

  // ── Hotel Management ───────────────────────────────────────────────────────

  Future<void> searchHotelsForTrip({
    String? city,
    DateTime? checkin,
    DateTime? checkout,
    int guests = 2,
  }) async {
    try {
      isSearchingHotels.value = true;
      hotelResults.clear();

      final searchCity = city ?? destinationController.text;
      if (searchCity.isEmpty) {
        showError('Please enter a city to search hotels');
        return;
      }

      final dateIn = checkin ?? startDate ?? DateTime.now();
      final dateOut = checkout ?? endDate ?? dateIn.add(const Duration(days: 1));

      final results = await _exploreRepo.exploreHotels(
        city: searchCity,
        checkin: _formatDate(dateIn),
        checkout: _formatDate(dateOut),
        guests: guests,
      );

      hotelResults.assignAll(results);
      if (results.isEmpty) {
        showError('No hotels found for the selected criteria');
      }
    } catch (error) {
      showError('Failed to search hotels: ${_readableError(error)}');
    } finally {
      isSearchingHotels.value = false;
    }
  }

  Future<void> addHotelToTripDay(
    String tripId,
    String dayId,
    HotelModel hotel,
  ) async {
    try {
      isLoading.value = true;

      // 1. Attach/Book the hotel for the trip using the requested endpoint /api/bookings/hotel
      final bookingData = {
        'tripId': tripId,
        'hotelId': hotel.id,
        'hotelName': hotel.name.isNotEmpty ? hotel.name : 'Hotel ${hotel.id}',
        'hotelLocation': hotel.location,
        'checkinDate': _formatDate(startDate ?? DateTime.now()),
        'checkoutDate': _formatDate(endDate ?? DateTime.now().add(const Duration(days: 1))),
        'guests': 2,
        'price': hotel.pricePerNight,
        'totalPrice': hotel.pricePerNight,
        'currency': 'USD',
      };

      await _tripRepo.attachHotel(bookingData);

      // 2. Also add it as a place/pin for that specific day if needed
      final hotelPlaceData = {
        'name': hotel.name,
        'address': hotel.location,
        'type': 'hotel',
        'hotelId': hotel.id,
        'price': hotel.pricePerNight,
        'image': hotel.imageUrl,
        'lat': 0.0, 
        'lng': 0.0,
      };

      await _tripRepo.addPlaceToDay(tripId, dayId, hotelPlaceData);
      
      await _refreshTrip(tripId);
      showSuccess('${hotel.name} added and booked for your trip!');
    } catch (error) {
      showError('Failed to add accommodation: ${_readableError(error)}');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Flight Management ──────────────────────────────────────────────────────

  Future<void> searchFlightsForTrip({
    String? from,
    String? to,
    DateTime? date,
    String flightClass = 'Economy',
  }) async {
    try {
      isSearchingFlights.value = true;
      flightResults.clear();

      final searchFrom = from ?? 'Cairo'; // Default origin
      final searchTo = to ?? destinationController.text;
      
      if (searchTo.isEmpty) {
        showError('Please enter a destination to search flights');
        return;
      }

      final searchDate = date ?? startDate ?? DateTime.now();

      final results = await _exploreRepo.exploreFlights(
        from: searchFrom,
        to: searchTo,
        date: _formatDate(searchDate),
        flightClass: flightClass,
      );

      flightResults.assignAll(results);
      if (results.isEmpty) {
        showError('No flights found for the selected criteria');
      }
    } catch (error) {
      showError('Failed to search flights: ${_readableError(error)}');
    } finally {
      isSearchingFlights.value = false;
    }
  }

  Future<void> addFlightToTripDay(
    String tripId,
    String dayId,
    FlightModel flight,
  ) async {
    try {
      isLoading.value = true;

      // 1. Attach/Book the flight for the trip - Updated to match backend requirement
      final bookingData = {
        'tripId': tripId,
        'flightId': flight.id,
        'airline': flight.airlineName,
        'flightNumber': flight.flightNumber,
        'departureAirport': flight.fromCode,
        'arrivalAirport': flight.toCode,
        'departureCity': flight.fromCity,
        'arrivalCity': flight.toCity,
        'departureDate': flight.departureTime.toIso8601String(),
        'arrivalDate': flight.arrivalTime.toIso8601String(),
        'passengers': 1,
        'cabinClass': flight.flightClass.toUpperCase(),
        'totalPrice': flight.price,
        'currency': 'USD',
        'bookingUrl': 'https://www.google.com/travel/flights',
        'type': 'flight',
      };

      await _tripRepo.attachFlight(bookingData);

      // 2. Add it as a record for that specific day
      final flightPlaceData = {
        'name': '${flight.airlineName} (${flight.flightNumber})',
        'address': 'From ${flight.fromCity} to ${flight.toCity}',
        'type': 'flight',
        'flightId': flight.id,
        'price': flight.price,
        'lat': 0.0, 
        'lng': 0.0,
      };

      await _tripRepo.addPlaceToDay(tripId, dayId, flightPlaceData);
      
      await _refreshTrip(tripId);
      showSuccess('Flight ${flight.flightNumber} added to your trip!');
    } catch (error) {
      showError('Failed to add flight: ${_readableError(error)}');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Place Management ───────────────────────────────────────────────────────

  Future<void> addPlaceToDay(
    String tripId,
    String dayId,
    Map<String, dynamic> placeData,
  ) async {
    try {
      await _tripRepo.addPlaceToDay(tripId, dayId, placeData);
      
      // Add marker to map
      final lat = placeData['lat'] as double? ?? 0.0;
      final lng = placeData['lng'] as double? ?? 0.0;
      if (lat != 0.0 && lng != 0.0) {
        final point = LatLng(lat, lng);
        markers.add(Marker(
          markerId: MarkerId(placeData['placeId'] ?? DateTime.now().toString()),
          position: point,
          infoWindow: InfoWindow(title: placeData['name'] ?? 'Place'),
        ));
        
        // Move camera to the new place
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(point, 12));
      }

      await _refreshTrip(tripId);
      showSuccess('Place added!');
    } catch (error) {
      showError('Failed to add place: ${_readableError(error)}');
    }
  }

  Future<void> removePlaceFromDay(
    String tripId,
    String dayId,
    int placeIndex,
  ) async {
    try {
      await _tripRepo.removePlaceFromDay(tripId, dayId, placeIndex);
      await _refreshTrip(tripId);
      showSuccess('Place removed!');
    } catch (error) {
      showError('Failed to remove place: ${_readableError(error)}');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Set map style to dark if possible or premium looking
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

      // The backend auto-creates days based on travel dates.
      // We either use the days from the response or fetch them if they are missing.
      List<TripDayModel> serverDays = createdTrip.days ?? [];
      
      if (serverDays.isEmpty) {
        serverDays = await _tripRepo.getTripDays(tripId);
      }

      _rebuildDays(serverDays);

      showSuccess('Trip initialized with ${serverDays.length} days!');
      Get.to(() => const PlanATripDetailsScreen());
    } catch (error) {
      final message = _readableError(error);
      errorMessage.value = message;
      showError('Failed to create trip: $message');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDay() async {
    final tripId = _createdTripId;
    if (tripId != null && tripId.isNotEmpty) {
      try {
        isLoading.value = true;
        final nextDayNumber = days.length + 1;
        final dayDate = startDate?.add(Duration(days: nextDayNumber - 1));
        final dayData = {
          'dayNumber': nextDayNumber,
          if (dayDate != null) 'date': _formatDate(dayDate),
        };
        final newDay = await _tripRepo.addDayToTrip(tripId, dayData);
        days.add(GuideDayModel(
          id: newDay.id,
          dayNumber: newDay.dayNumber,
          place: newDay.title ?? '',
          notes: newDay.notes ?? '',
        ));
        showSuccess('Day ${newDay.dayNumber} added');
      } catch (error) {
        showError('Failed to add day: ${_readableError(error)}');
      } finally {
        isLoading.value = false;
      }
    } else {
      days.add(GuideDayModel(dayNumber: days.length + 1));
    }
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
        };

        if (day.id != null && day.id!.isNotEmpty) {
          await _tripRepo.updateDay(tripId, day.id!, dayData);
        } else {
          final newDay = await _tripRepo.addDayToTrip(tripId, dayData);
          // Update local day with ID from server if we just created it
          // This is a safety measure in case a day was added locally without API call
        }
      }

      final refreshed = await _refreshTrip(tripId);
      if (refreshed) {
        showSuccess('Trip saved successfully!');
      } else {
        showError('Trip saved, but latest details could not be refreshed.');
      }

      // Pop planning screens and go back to previous main screen (Home/Profile)
      Get.close(2); 
      
      // Refresh SavedTripsController if it exists to show the new trip in the list
      try {
        final savedController = Get.find<SavedTripsController>();
        savedController.fetchTrips();
      } catch (_) {}
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
      final customPlaces = day.locations
          .where((loc) =>
              (loc.type ?? '').toLowerCase() != 'hotel' &&
              (loc.type ?? '').toLowerCase() != 'flight')
          .toList();
      if (customPlaces.isNotEmpty) {
        buffer.writeln('Places:');
        for (final loc in customPlaces) {
          buffer.writeln(' - ${loc.name}${loc.address != null ? ' (${loc.address})' : ''}');
        }
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
    if (destinationController.text.trim().isEmpty) {
      errorMessage.value = 'Please pick a destination city';
      showError(errorMessage.value);
      return false;
    }
    if (titleController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter a trip title';
      showError(errorMessage.value);
      return false;
    }
    if (startDate == null || endDate == null) {
      errorMessage.value = 'Please select start and end dates';
      showError(errorMessage.value);
      return false;
    }
    return true;
  }

  TripModel _buildBaseTrip() {
    return TripModel(
      id: '',
      title: titleController.text.trim(),
      destination: destinationController.text.trim(),
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : null,
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
      
      if (refreshedTrip.days != null) {
        _syncDays(refreshedTrip.days!);
      }
      
      errorMessage.value = '';
      return true;
    } catch (error) {
      errorMessage.value = _readableError(error);
      return false;
    }
  }

  void _syncDays(List<TripDayModel> serverDays) {
    for (var sDay in serverDays) {
      // Find existing day by ID or dayNumber
      final existingDay = days.firstWhereOrNull(
        (d) => d.id == sDay.id || d.dayNumber == sDay.dayNumber,
      );

      if (existingDay != null) {
        // Update existing day without disposing controllers
        if (sDay.title != null && sDay.title != existingDay.place.value) {
          existingDay.place.value = sDay.title!;
          existingDay.placeController.text = sDay.title!;
        }
        if (sDay.notes != null && sDay.notes != existingDay.notes.value) {
          existingDay.notes.value = sDay.notes!;
          existingDay.notesController.text = sDay.notes!;
        }
        
        // Update address from first location if available (excluding hotels which have their own cards)
        if (sDay.locations != null && sDay.locations!.isNotEmpty) {
          final nonHotelLocations = sDay.locations!.where((loc) => (loc.type ?? '').toLowerCase() != 'hotel').toList();
          if (nonHotelLocations.isNotEmpty) {
            final firstLoc = nonHotelLocations.first.name;
            if (firstLoc != existingDay.address.value) {
              existingDay.address.value = firstLoc;
              existingDay.addressController.text = firstLoc;
            }
          }
        }

        // Sync Bookings (Hotels, etc.)
        if (sDay.bookings != null) {
          existingDay.bookings.assignAll(sDay.bookings!);
        }

        // Sync Locations (Places, etc.)
        if (sDay.locations != null) {
          existingDay.locations.assignAll(sDay.locations!);
        }
      } else {
        // If it's a completely new day, add it
        days.add(GuideDayModel(
          id: sDay.id,
          dayNumber: sDay.dayNumber,
          place: sDay.title ?? '',
          notes: sDay.notes ?? '',
          address: (sDay.locations != null && sDay.locations!.isNotEmpty)
              ? sDay.locations!.first.name
              : '',
          bookings: sDay.bookings ?? [],
          locations: sDay.locations ?? [],
        ));
      }
    }
    
    // Sort days to ensure they stay in order
    days.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));
  }

  void _rebuildDays(List<TripDayModel> serverDays) {
    // Clear the list first to notify observers (UI) to stop using these models
    final oldDays = List<GuideDayModel>.from(days);
    days.clear();
    
    // Now safely dispose old controllers
    for (final day in oldDays) {
      day.dispose();
    }

    for (var sDay in serverDays) {
      String initialAddress = '';
      if (sDay.locations != null && sDay.locations!.isNotEmpty) {
        initialAddress = sDay.locations!.first.name;
      }

      days.add(GuideDayModel(
        id: sDay.id,
        dayNumber: sDay.dayNumber,
        place: sDay.title ?? '',
        notes: sDay.notes ?? '',
        address: initialAddress,
        bookings: sDay.bookings ?? [],
        locations: sDay.locations ?? [],
      ));
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
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
