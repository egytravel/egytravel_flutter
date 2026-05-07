import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:get/get.dart';

class SavedTripsController extends GetxController {
  final TripRepo _tripRepo = TripRepo();

  final RxList<TripModel> trips = <TripModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  /// GET /trips?status=planning
  Future<void> fetchTrips({String status = 'planning'}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      final fetchedTrips = await _tripRepo.getAllTrips(status: status);
      trips.assignAll(fetchedTrips);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      showError('Failed to load trips');
    } finally {
      isLoading.value = false;
    }
  }

  /// POST /trips
  Future<TripModel?> createTrip(TripModel trip) async {
    try {
      final created = await _tripRepo.createTrip(trip);
      trips.insert(0, created); // Add to top of list
      showSuccess('Trip created!');
      return created;
    } catch (e) {
      showError('Failed to create trip: ${e.toString().replaceAll('Exception: ', '')}');
      return null;
    }
  }

  /// PUT /trips/{id}
  Future<void> updateTrip(String id, Map<String, dynamic> updates) async {
    try {
      final updated = await _tripRepo.updateTrip(id, updates);
      final index = trips.indexWhere((t) => t.id == id);
      if (index != -1) {
        trips[index] = updated;
        trips.refresh();
      }
      showSuccess('Trip updated!');
    } catch (e) {
      showError('Failed to update trip');
    }
  }

  /// DELETE /trips/{id}
  Future<void> deleteTrip(String id) async {
    try {
      await _tripRepo.deleteTrip(id);
      trips.removeWhere((t) => t.id == id);
      showSuccess('Trip deleted');
    } catch (e) {
      showError('Failed to delete trip');
    }
  }
}
