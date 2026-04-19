import 'dart:ui';
import 'package:egytravel_app/feature/wallet/logic/models/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  final double total;
  final int count;

  const ExpenseCategoryCard({
    super.key,
    required this.category,
    required this.total,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count ${count == 1 ? 'expense' : 'expenses'}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                'EGP ${total.toStringAsFixed(0)}',
                style: TextStyle(
                  color: _getCategoryColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category) {
      case ExpenseCategory.hotel:
        return const Color(0xFF6366F1);
      case ExpenseCategory.flight:
        return const Color(0xFF3B82F6);
      case ExpenseCategory.restaurant:
        return const Color(0xFFF59E0B);
      case ExpenseCategory.shopping:
        return const Color(0xFFEC4899);
      case ExpenseCategory.activities:
        return const Color(0xFF10B981);
    }
  }
}
