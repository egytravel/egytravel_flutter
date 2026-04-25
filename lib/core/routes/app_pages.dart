import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/binding/trip_binding.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/screens/ai_trip_planner_screen.dart';
import 'package:egytravel_app/feature/auth/logic/binding/login_binding.dart';
import 'package:egytravel_app/feature/auth/ui/screens/login_view.dart';
import 'package:egytravel_app/feature/booking/ui/screen/booking_screen.dart';
import 'package:egytravel_app/feature/home/ui/screen/home_screen.dart';
import 'package:egytravel_app/feature/home/ui/screen/search_screen.dart';
import 'package:egytravel_app/feature/home/ui/screen/event_details_screen.dart';
import 'package:egytravel_app/feature/onboarding/ui/screen/onboarding_screen.dart';
import 'package:egytravel_app/feature/splash/logic/binding/splash_binding.dart';
import 'package:egytravel_app/feature/splash/ui/screen/splash_screen.dart';
import 'package:egytravel_app/feature/explore/ui/screen/explore_listing_screen.dart';
import 'package:egytravel_app/feature/explore/ui/screen/map_view_screen.dart';
import 'package:egytravel_app/feature/explore/ui/screen/explore_details_screen.dart';
import 'package:egytravel_app/feature/home/logic/binding/search_binding.dart';
import 'package:egytravel_app/feature/community/ui/screen/community_screen.dart';
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
    ),
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(
      name: Routes.tripPlanner,
      page: () => PlanTripScreen(),
      binding: TripBinding(),
    ),
    GetPage(name: Routes.search, page: () => const SearchScreen(), binding: SearchBinding()),
    GetPage(name: Routes.bookingScreen, page: () => const BookingScreen()),
    GetPage(
      name: Routes.exploreListing,
      page: () => const ExploreListingScreen(),
    ),
    GetPage(name: Routes.mapView, page: () => const MapViewScreen()),
    GetPage(
      name: Routes.exploreDetails,
      page: () => const ExploreDetailsScreen(),
    ),
    GetPage(
      name: Routes.community,
      page: () => const CommunityScreen(),
    ),
    GetPage(
      name: Routes.eventDetails,
      page: () => const EventDetailsScreen(),
    ),
  ];
}
