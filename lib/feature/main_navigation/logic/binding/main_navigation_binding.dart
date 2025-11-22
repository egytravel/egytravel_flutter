import 'package:get/get.dart';
import '../../../trip_planner/logic/controller/trip_planner_controller.dart';
import '../../../trip_planner/logic/binding/trip_planner_binding.dart';
import '../../ui/controller/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainNavigationController>(MainNavigationController());
    
    // Initialize trip planner binding
    TripPlannerBinding().dependencies();
  }
}