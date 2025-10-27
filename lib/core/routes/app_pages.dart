import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/auth/logic/binding/login_binding.dart';
import 'package:egytravel_app/feature/auth/ui/screens/login_view.dart';
import 'package:egytravel_app/feature/onboarding/ui/screen/onboarding_screen.dart';

import 'package:egytravel_app/feature/splash/logic/binding/splash_binding.dart';
import 'package:egytravel_app/feature/splash/ui/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static const initial = Routes.splashScreen;

  static List<GetPage> appPages() => [
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.onboardingScreen,
      page: () => const OnboardingScreen(),
      // binding: OnboardingBinding(),
    ),
  ];
}
