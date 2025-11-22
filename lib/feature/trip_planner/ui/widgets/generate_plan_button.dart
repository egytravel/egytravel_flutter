import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
import '../../logic/controller/trip_planner_controller.dart';
//
// class GeneratePlanButton extends StatelessWidget {
//   const GeneratePlanButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<TripPlannerController>();
//
//     return Obx(() => AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: double.infinity,
//       height: 60,
//       child: ElevatedButton(
//         onPressed: controller.isGeneratingPlan.value
//             ? null
//             : () => controller.generateTripPlan(),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColor.primary,
//           foregroundColor: Colors.white,
//           elevation: controller.isGeneratingPlan.value ? 0 : 8,
//           shadowColor: AppColor.primary.withOpacity(0.3),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: controller.isGeneratingPlan.value
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Crafting Your Adventure...',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.auto_awesome,
//                     size: 24,
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Generate AI Trip Plan',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     ));
//   }
// }

class GeneratePlanButton extends StatelessWidget {
  const GeneratePlanButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripPlannerController>();

    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.canGeneratePlan
            ? () => controller.generateItinerary()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: controller.canGeneratePlan ? Colors.white : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              'Generate AI Trip Plan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.canGeneratePlan ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}