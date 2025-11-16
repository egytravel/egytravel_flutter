import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_color.dart';
//
// class DateSelector extends StatelessWidget {
//   final String title;
//   final Rx<DateTime?> selectedDate;
//   final VoidCallback onTap;
//   final IconData icon;
//
//   const DateSelector({
//     super.key,
//     required this.title,
//     required this.selectedDate,
//     required this.onTap,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: AppColor.primary.withOpacity(0.3),
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: AppColor.primary.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: AppColor.primary,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Obx(() => Text(
//               selectedDate.value != null
//                   ? _formatDate(selectedDate.value!)
//                   : 'Select Date',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: selectedDate.value != null
//                     ? Colors.brown.shade700
//                     : Colors.grey.shade500,
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }
// }


class DateSelector extends StatelessWidget {
  final String title;
  final Rx<DateTime?> selectedDate;
  final VoidCallback onTap;
  final IconData icon;

  const DateSelector({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.orange, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate.value == null
                      ? 'Select'
                      : '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedDate.value == null
                        ? Colors.grey[500]
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}