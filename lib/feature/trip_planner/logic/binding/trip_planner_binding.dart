import 'package:get/get.dart';
import '../controller/trip_planner_controller.dart';

class TripPlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripPlannerController>(() => TripPlannerController());
  }
}