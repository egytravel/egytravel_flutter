import 'package:egytravel_app/feature/booking/data/models/flight_model.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/booking/data/models/hotel_model.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  // Tab management
  var currentTabIndex = 0.obs;

  // Flight search parameters
  var flightFrom = ''.obs;
  var flightTo = ''.obs;
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
  var hotelResults = <HotelModel>[].obs;

  // Loading states
  var isSearchingFlights = false.obs;
  var isSearchingHotels = false.obs;

  // Has searched flags
  var hasSearchedFlights = false.obs;
  var hasSearchedHotels = false.obs;

  // Search flights
  void searchFlights() {
    if (flightFrom.value.isEmpty || flightTo.value.isEmpty) {
      showError('Please enter departure and arrival cities');
      return;
    }

    isSearchingFlights.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      flightResults.value = FlightModel.getMockFlights(
        from: flightFrom.value,
        to: flightTo.value,
        flightClass: flightClass.value,
      );
      isSearchingFlights.value = false;
      hasSearchedFlights.value = true;
    });
  }

  // Search hotels
  void searchHotels() {
    if (hotelDestination.value.isEmpty) {
      showError('Please enter a destination');
      return;
    }

    isSearchingHotels.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      hotelResults.value = HotelModel.getMockHotels(
        destination: hotelDestination.value,
      );
      isSearchingHotels.value = false;
      hasSearchedHotels.value = true;
    });
  }

  // Reset flight search
  void resetFlightSearch() {
    flightFrom.value = '';
    flightTo.value = '';
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
