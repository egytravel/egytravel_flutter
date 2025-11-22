import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/home_screen_body.dart';
import 'package:egytravel_app/feature/profile/ui/screen/profile_screen.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [
    const HomeScreenBody(),
    const ProfileScreen(),
    const HomeScreenBody(),
    const ProfileScreen(),
    const ProfileScreen(),
  ];

  int selectedItem = 0;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  // Method to show SpeedDial options when "add" is tapped
  void _showAddOptions() {
    // Toggle the SpeedDial
    isDialOpen.value = !isDialOpen.value;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      key: controller.scaffoldKey,
      body: pages[selectedItem],
      backgroundColor: Colors.transparent,
      extendBody: true,
      floatingActionButton: SpeedDial(
        openCloseDial: isDialOpen,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.orange,
        activeForegroundColor: Colors.white,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.public),
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
            label: 'Trip Plan',
            labelStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            labelBackgroundColor: Colors.white,
            onTap: () {
              // Navigate to Trip Plan screen
              // Get.toNamed('/trip-plan');
              // OR
              // Get.to(() => TripPlanScreen());

              Get.snackbar(
                'Trip Plan',
                'Navigate to Trip Plan screen',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.explore),
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
            label: 'Guide',
            labelStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            labelBackgroundColor: Colors.white,
            onTap: () {
              // Navigate to Guide screen
              // Get.toNamed('/guide');
              // OR
              // Get.to(() => GuideScreen());

              Get.snackbar(
                'Guide',
                'Navigate to Guide screen',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColor.primary,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColor.primary.withValues(alpha: 0.7),
        items: [
          CurvedNavigationBarItem(
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(Assets.iconsHome),
            ),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(Assets.iconsSearch),
            ),
            label: 'Search',
          ),
          const CurvedNavigationBarItem(
            child: SizedBox(
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          CurvedNavigationBarItem(
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(Assets.iconsExplore),
            ),
            label: 'Explore',
          ),
          CurvedNavigationBarItem(
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(Assets.iconsProfile),
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // If "Add" button area is tapped, toggle SpeedDial
            _showAddOptions();
          } else {
            setState(() {
              selectedItem = index;
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    isDialOpen.dispose();
    super.dispose();
  }
}