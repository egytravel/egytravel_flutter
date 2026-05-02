import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:get/get.dart';

class SavedTripsController extends GetxController {
  final TripRepo _tripRepo = Get.put(TripRepo());

  final RxList<TripModel> trips = <TripModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    try {
      isLoading.value = true;
      final fetchedTrips = await _tripRepo.getAllTrips();
      trips.assignAll(fetchedTrips);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load trips: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTrip(String id) async {
    try {
      await _tripRepo.deleteTrip(id);
      trips.removeWhere((t) => t.id == id);
      Get.snackbar('Success', 'Trip deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete trip: $e');
    }
  }
}
