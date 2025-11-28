import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:get/get.dart';

class  TripBinding extends Bindings {
  @override
  void dependencies() {
Get.lazyPut(() => TripController(),) ; }
}