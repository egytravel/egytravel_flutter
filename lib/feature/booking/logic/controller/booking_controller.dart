import 'package:egytravel_app/feature/booking/data/models/flight_model.dart';
import 'package:egytravel_app/feature/booking/data/models/flight_location_model.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/booking/data/models/hotel_model.dart';
import 'package:egytravel_app/feature/booking/data/repo/booking_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  final BookingRepo _bookingRepo = BookingRepo();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // Tab management
  var currentTabIndex = 0.obs;

  // Flight search parameters
  var flightFrom = ''.obs;
  var flightTo = ''.obs;
  var selectedFlightFrom = Rx<FlightLocationModel?>(null);
  var selectedFlightTo = Rx<FlightLocationModel?>(null);
  var flightDepartureDate = Rx<DateTime?>(null);
  var flightReturnDate = Rx<DateTime?>(null);
  var flightTravelers = 1.obs;
  var flightClass = 'Economy'.obs;

  // Hotel search parameters
  var hotelDestination = ''.obs;
  var hotelCheckInDate = Rx<DateTime?>(null);
  var hotelCheckOutDate = Rx<DateTime?>(null);
  var hotelGuests = 1.obs;
  var hotelRooms = 1.obs;

  // Search results
  var flightResults = <FlightModel>[].obs;
  var flightLocations = <FlightLocationModel>[].obs;
  var hotelResults = <HotelModel>[].obs;

  // Loading states
  var isSearchingFlights = false.obs;
  var isSearchingHotels = false.obs;

  // Has searched flags
  var hasSearchedFlights = false.obs;
  var hasSearchedHotels = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFlightLocations();
  }

  Future<void> fetchFlightLocations() async {
    try {
      final locations = await _bookingRepo.getFlightLocations();
      flightLocations.assignAll(locations);
    } catch (e) {
      // Silently fail or log, as this is pre-fetching
      print('Error fetching flight locations: $e');
    }
  }

  // Search flights
  Future<void> searchFlights() async {
    if (flightFrom.value.isEmpty || flightTo.value.isEmpty) {
      showError('Please enter departure and arrival cities');
      return;
    }

    if (flightDepartureDate.value == null) {
      showError('Please select a departure date');
      return;
    }

    isSearchingFlights.value = true;
    try {
      final results = await _bookingRepo.searchFlights(
        origin: selectedFlightFrom.value?.code ?? flightFrom.value,
        destination: selectedFlightTo.value?.code ?? flightTo.value,
        departureDate: _dateFormat.format(flightDepartureDate.value!),
        returnDate: flightReturnDate.value != null 
            ? _dateFormat.format(flightReturnDate.value!) 
            : null,
        adults: flightTravelers.value,
        travelClass: flightClass.value.toUpperCase(),
      );
      flightResults.assignAll(results);
      hasSearchedFlights.value = true;
    } catch (e) {
      showError('Failed to search flights: ${e.toString()}');
    } finally {
      isSearchingFlights.value = false;
    }
  }

  // Search hotels
  Future<void> searchHotels() async {
    if (hotelDestination.value.isEmpty) {
      showError('Please enter a destination');
      return;
    }

    if (hotelCheckInDate.value == null || hotelCheckOutDate.value == null) {
      showError('Please select check-in and check-out dates');
      return;
    }

    isSearchingHotels.value = true;
    try {
      final results = await _bookingRepo.searchHotels(
        location: hotelDestination.value,
        checkin: _dateFormat.format(hotelCheckInDate.value!),
        checkout: _dateFormat.format(hotelCheckOutDate.value!),
        guests: hotelGuests.value,
        rooms: hotelRooms.value,
      );
      hotelResults.assignAll(results);
      hasSearchedHotels.value = true;
    } catch (e) {
      showError('Failed to search hotels: ${e.toString()}');
    } finally {
      isSearchingHotels.value = false;
    }
  }

  // Reset flight search
  void resetFlightSearch() {
    flightFrom.value = '';
    flightTo.value = '';
    selectedFlightFrom.value = null;
    selectedFlightTo.value = null;
    flightDepartureDate.value = null;
    flightReturnDate.value = null;
    flightTravelers.value = 1;
    flightClass.value = 'Economy';
    flightResults.clear();
    hasSearchedFlights.value = false;
  }

  // Reset hotel search
  void resetHotelSearch() {
    hotelDestination.value = '';
    hotelCheckInDate.value = null;
    hotelCheckOutDate.value = null;
    hotelGuests.value = 1;
    hotelRooms.value = 1;
    hotelResults.clear();
    hasSearchedHotels.value = false;
  }
}
