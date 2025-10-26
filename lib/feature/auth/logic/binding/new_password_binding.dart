import 'package:egytravel_app/feature/auth/logic/controller/newPassword_controller.dart';
import 'package:get/get.dart';

class NewPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewPasswordController());
  }
}