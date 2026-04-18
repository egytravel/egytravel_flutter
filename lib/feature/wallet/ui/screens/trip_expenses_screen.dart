import 'package:egytravel_app/core/models/trip_model.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/wallet/logic/controller/wallet_controller.dart';
import 'package:egytravel_app/feature/wallet/logic/models/expense_model.dart';
import 'package:egytravel_app/feature/wallet/ui/widgets/add_expense_dialog.dart';
import 'package:egytravel_app/feature/wallet/ui/widgets/expense_category_card.dart';
import 'package:egytravel_app/feature/wallet/ui/widgets/expense_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripExpensesScreen extends StatelessWidget {
  final Trip trip;

  const TripExpensesScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            // Trigger rebuild when expenses change
            controller.getExpensesForTrip(trip.id);

            final totalExpenses = controller.getTotalForTrip(trip.id);
            final expenses = controller.getExpensesForTrip(trip.id);

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          children: [
                            const CustomBackButton(),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip.destination,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    trip.dateRange,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Total Expenses Card
                        _buildTotalCard(totalExpenses),
                        const SizedBox(height: 24),

                        // Category Breakdown Header
                        Row(
                          children: [
                            const Icon(
                              Icons.category_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'By Category',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${ExpenseCategory.values.length} categories',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Category Cards
                        ...ExpenseCategory.values.map((category) {
                          final catTotal = controller.getCategoryTotal(
                            trip.id,
                            category,
                          );
                          final catCount = expenses
                              .where((e) => e.category == category)
                              .length;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ExpenseCategoryCard(
                              category: category,
                              total: catTotal,
                              count: catCount,
                            ),
                          );
                        }),

                        const SizedBox(height: 24),

                        // Recent Expenses Header
                        if (expenses.isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long_rounded,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'All Expenses',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${expenses.length} items',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Expense Items
                          ...expenses.reversed.map(
                            (expense) => ExpenseListItem(
                              expense: expense,
                              onDelete: () =>
                                  controller.deleteExpense(trip.id, expense.id),
                            ),
                          ),
                        ],

                        // Empty State
                        if (expenses.isEmpty) _buildEmptyState(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        // FAB to add expense
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AddExpenseDialog(tripId: trip.id),
            );
          },
          backgroundColor: const Color(0xFF6366F1),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Add Expense',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6366F1).withOpacity(0.3),
            const Color(0xFF8B5CF6).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total Expenses',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'EGP ${total.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 48,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the button below to start tracking\nyour spending for this trip.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
