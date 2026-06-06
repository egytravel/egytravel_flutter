import 'package:egytravel_app/feature/ai_trip_planner/data/repo/ai_trip_repo.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/chat_controller.dart';
import 'package:get/get.dart';

class AiTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiTripRepository>(() => AiTripRepositoryImpl());
    Get.lazyPut(() => TripController(Get.find()));
    Get.lazyPut(() => ChatController(Get.find()));
  }
}
