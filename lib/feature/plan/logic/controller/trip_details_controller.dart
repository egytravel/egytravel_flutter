import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:get/get.dart';

class TripDetailsController extends GetxController {
  final TripRepo _tripRepo = Get.put(TripRepo());
  final String tripId;

  TripDetailsController(this.tripId);

  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTripDetails();
  }

  Future<void> fetchTripDetails() async {
    try {
      isLoading.value = true;
      final data = await _tripRepo.getTripDetails(tripId);
      trip.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load trip details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateActivity(String dayId, Map<String, dynamic> data) async {
    // Logic to update activity in a day
  }
}
