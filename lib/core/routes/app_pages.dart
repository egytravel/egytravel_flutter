import 'package:egytravel_app/core/routes/app_routes.dart';

import 'package:egytravel_app/feature/splash/logic/binding/splash_binding.dart';
import 'package:egytravel_app/feature/splash/ui/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static const initial = Routes.loginView;

  static List<GetPage> appPages() => [
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.loginView,
      page: () => const LoginScreen(),

  ];
}
