import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
import '../../logic/controller/trip_planner_controller.dart';
//
// class BudgetSelector extends StatelessWidget {
//   const BudgetSelector({super.key});
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
//                 Icons.account_balance_wallet,
//                 color: AppColor.primary,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Select Your Budget',
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
//           Column(
//             children: controller.budgetRanges.map((budget) {
//               return Obx(() => GestureDetector(
//                 onTap: () => controller.selectBudgetRange(budget.value),
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: controller.selectedBudgetRange.value == budget.value
//                         ? AppColor.primary.withOpacity(0.1)
//                         : Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: controller.selectedBudgetRange.value == budget.value
//                           ? AppColor.primary
//                           : Colors.grey.shade300,
//                       width: controller.selectedBudgetRange.value == budget.value ? 2 : 1,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: controller.selectedBudgetRange.value == budget.value
//                                 ? AppColor.primary
//                                 : Colors.grey.shade400,
//                             width: 2,
//                           ),
//                           color: controller.selectedBudgetRange.value == budget.value
//                               ? AppColor.primary
//                               : Colors.transparent,
//                         ),
//                         child: controller.selectedBudgetRange.value == budget.value
//                             ? const Icon(
//                                 Icons.check,
//                                 color: Colors.white,
//                                 size: 14,
//                               )
//                             : null,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               budget.title,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: controller.selectedBudgetRange.value == budget.value
//                                     ? AppColor.primary
//                                     : Colors.brown.shade700,
//                               ),
//                             ),
//                             Text(
//                               budget.range,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         _getBudgetIcon(budget.value),
//                         color: controller.selectedBudgetRange.value == budget.value
//                             ? AppColor.primary
//                             : Colors.grey.shade500,
//                         size: 24,
//                       ),
//                     ],
//                   ),
//                 ),
//               ));
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   IconData _getBudgetIcon(String budgetType) {
//     switch (budgetType) {
//       case 'budget':
//         return Icons.backpack;
//       case 'comfort':
//         return Icons.hotel;
//       case 'luxury':
//         return Icons.diamond;
//       case 'royal':
//         return Icons.castle;
//       default:
//         return Icons.account_balance_wallet;
//     }
//   }
// }

class BudgetSelector extends StatelessWidget {
  const BudgetSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripPlannerController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.attach_money,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Budget Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.budgetOptions.map((budget) {
            final isSelected = controller.selectedBudget.value == budget.value;
            return InkWell(
              onTap: () => controller.selectedBudget.value = budget.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  budget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}