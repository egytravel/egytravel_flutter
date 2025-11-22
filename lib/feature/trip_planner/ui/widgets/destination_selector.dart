// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/theme/app_color.dart';
// import '../../logic/controller/trip_planner_controller.dart';
//
// class DestinationSelector extends StatelessWidget {
//   const DestinationSelector({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<TripPlannerController>();
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: AppColor.primary.withOpacity(0.3),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.primary.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.location_on,
//                 color: AppColor.primary,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Choose Your Destination',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.brown.shade700,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           // Destination Input Field
//           TextField(
//             controller: controller.destinationController,
//             decoration: InputDecoration(
//               hintText: 'Select or type your destination...',
//               hintStyle: TextStyle(color: Colors.grey.shade500),
//               prefixIcon: Icon(Icons.search, color: AppColor.primary),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: AppColor.primary, width: 2),
//               ),
//               filled: true,
//               fillColor: Colors.grey.shade50,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Popular Destinations
//           Text(
//             'Popular Destinations',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: controller.popularDestinations.map((destination) {
//               return Obx(() => GestureDetector(
//                 onTap: () => controller.selectDestination(destination),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: controller.selectedDestination.value == destination
//                         ? AppColor.primary
//                         : Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: controller.selectedDestination.value == destination
//                           ? AppColor.primary
//                           : Colors.grey.shade300,
//                     ),
//                   ),
//                   child: Text(
//                     destination,
//                     style: TextStyle(
//                       color: controller.selectedDestination.value == destination
//                           ? Colors.white
//                           : Colors.grey.shade700,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ));
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:egytravel_app/feature/trip_planner/logic/controller/trip_planner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DestinationSelector extends StatelessWidget {
  const DestinationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripPlannerController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Destination',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedDestination.value.isEmpty
                  ? null
                  : controller.selectedDestination.value,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select destination',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_drop_down, color: Colors.orange),
              ),
              items: controller.destinations.map((destination) {
                return DropdownMenuItem(
                  value: destination,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      destination,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedDestination.value = value;
                }
              },
            ),
          ),
        )),
      ],
    );
  }
}