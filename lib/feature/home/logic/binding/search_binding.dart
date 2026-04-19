import 'package:egytravel_app/feature/home/logic/controller/search_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppSearchController>(() => AppSearchController());
  }
}
