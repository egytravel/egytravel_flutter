import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/booking/logic/controller/booking_controller.dart';
import 'package:egytravel_app/feature/booking/ui/widgets/flights/flights_tab.dart';
import 'package:egytravel_app/feature/booking/ui/widgets/hotels/hotels_tab.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final HomeNavigationController navController;

  @override
  void initState() {
    super.initState();
    // Initialize controller
    Get.put(BookingController());
    navController = Get.find<HomeNavigationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = navController.selectedBookingTab.value;

      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/Splash_Screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              forceMaterialTransparency: true,
              centerTitle: true,
              title: const Text(
                'Booking',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: [
                // Custom Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton(
                              index: 0,
                              icon: Icons.flight_takeoff_rounded,
                              label: 'Flights',
                              isSelected: selectedIndex == 0,
                            ),
                            const SizedBox(width: 8),
                            _buildTabButton(
                              index: 1,
                              icon: Icons.hotel_rounded,
                              label: 'Hotels',
                              isSelected: selectedIndex == 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Tab Content
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: const [FlightsTab(), HotelsTab()],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          navController.selectedBookingTab.value = index;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
