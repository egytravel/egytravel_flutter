import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/snak_bar.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/screens/ai_trip_planner_screen.dart';
import 'package:egytravel_app/feature/guid_trip/ui/screens/guid_trip_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFloatingMenu extends StatefulWidget {
  static final GlobalKey<_CustomFloatingMenuState> menuKey =
  GlobalKey<_CustomFloatingMenuState>();

  const CustomFloatingMenu({super.key});

  @override
  State<CustomFloatingMenu> createState() => _CustomFloatingMenuState();
}


class _CustomFloatingMenuState extends State<CustomFloatingMenu>
    with SingleTickerProviderStateMixin {

  bool isOpen = false;

  void toggle() {
    setState(() => isOpen = !isOpen);
  }

  void close() {
    if (isOpen) {
      setState(() => isOpen = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isOpen,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// ===== خلفية شبه شفافة لما المينيو تفتح =====
          if (isOpen)
            GestureDetector(
              onTap: () => setState(() => isOpen = false),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isOpen ? 0.5 : 0,
                child: Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

          /// ===== زرارين جنب بعض (Zoom In / Out) =====
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: isOpen ? 120 : -150,   // يطلع من خارج الشاشة
            child: AnimatedOpacity(
              opacity: isOpen ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: AnimatedScale(
                scale: isOpen ? 1 : 0,       // <<<<<< ZOOM IN / OUT
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,  // انيميشن نطّة بسيطة (جميل جداً)
                child: Row(
                  children: [

                    _buildMenuButton(
                      icon: Icons.public,
                      text: "Trip plan",
                      onTap: () {
                        Get.toNamed( Routes.tripPlanner);
                        showTopGlassSnackBar(context, 'Navigate to Trip Plan screen',success: true);

                      },
                    ),

                    const SizedBox(width: 16),

                    _buildMenuButton(
                      icon: Icons.explore,
                      text: "Guide",
                      onTap: () {
                        Get.to(() => const GuideTripScreen());
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
              ),
            ),
          ),


        ],
      ),
    );
  }

  /// ===== Button Widget =====
  Widget _buildMenuButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Even smaller width
        height: 70, // Even smaller height
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Slightly smaller radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColor.primary, size: 30), // Smaller icon
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14, // Smaller font
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
