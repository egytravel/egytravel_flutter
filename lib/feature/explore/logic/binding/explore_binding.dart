import 'package:egytravel_app/feature/explore/data/repo/explore_repo.dart';
import 'package:egytravel_app/feature/explore/logic/controller/explore_controller.dart';
import 'package:get/get.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExploreRepo());
    Get.lazyPut(() => ExploreController(repo: Get.find<ExploreRepo>()));
  }
}
