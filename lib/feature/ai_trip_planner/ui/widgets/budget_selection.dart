import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/budgetchip_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/glass_container_widget.dart';
import 'package:flutter/material.dart';

class BudgetSection extends StatelessWidget {
  final TripController controller;
  const BudgetSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children:  [
                Icon(Icons.account_balance_wallet, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Text('Trip Budget (Estimated)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: BudgetChip(label: 'Budget', controller: controller)),
                const SizedBox(width: 8),
                Expanded(child: BudgetChip(label: 'Medium', controller: controller)),
                const SizedBox(width: 8),
                Expanded(child: BudgetChip(label: 'Luxury', controller: controller)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}