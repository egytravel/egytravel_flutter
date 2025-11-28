import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';

class BudgetChip extends StatelessWidget {
  final String label;
  final TripController controller;

  const BudgetChip({required this.label, required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedBudget == label;

    return GestureDetector(
      onTap: () {
        controller.setBudget(label); // Function in controller to update selectedBudget
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              label == 'Budget'
                  ? Icons.savings
                  : label == 'Medium'
                  ? Icons.account_balance
                  : Icons.diamond,
              size: 22,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
