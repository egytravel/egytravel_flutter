import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/feature/guid_trip/ui/screens/guid_trip_screen.dart';
import 'dart:ui';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.flight_takeoff_rounded,
                  label: 'Flights',
                  onTap: () {
                    final navController = Get.find<HomeNavigationController>();
                    navController.navigateToBookingTab(bookingTabIndex: 0);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.hotel_rounded,
                  label: 'Hotels',
                  onTap: () {
                    final navController = Get.find<HomeNavigationController>();
                    navController.navigateToBookingTab(bookingTabIndex: 1);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.tour_rounded,
                  label: 'Tours',
                  onTap: () {
                    Get.toNamed(Routes.tripPlanner);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.person_pin_circle_rounded,
                  label: 'Guides',
                  onTap: () {
                    Get.to(
                      () => const GuideTripScreen(),
                      transition: Transition.rightToLeftWithFade,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isPressed
                      ? AppColor.primaryColor.withOpacity(0.5)
                      : Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColor.primaryColor.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: _isPressed ? 12 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isPressed
                          ? AppColor.primaryColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: _isPressed
                          ? AppColor.primaryColor
                          : Colors.white70,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: _isPressed
                          ? AppColor.primaryColor
                          : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
