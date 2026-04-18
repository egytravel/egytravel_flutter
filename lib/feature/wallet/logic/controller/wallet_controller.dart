import 'package:egytravel_app/core/models/trip_model.dart';
import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:egytravel_app/feature/wallet/logic/models/expense_model.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  /// Pulls trips from ProfileController so they stay in sync
  List<Trip> get trips {
    try {
      final profileController = Get.find<ProfileController>();
      return profileController.userTrips.toList();
    } catch (_) {
      return [];
    }
  }

  /// All expenses stored by tripId
  final RxMap<String, List<Expense>> _expensesByTrip =
      <String, List<Expense>>{}.obs;

  /// Currently selected trip id
  final selectedTripId = ''.obs;

  /// Get expenses for a specific trip
  List<Expense> getExpensesForTrip(String tripId) {
    return _expensesByTrip[tripId] ?? [];
  }

  /// Get total expenses for a specific trip
  double getTotalForTrip(String tripId) {
    final expenses = getExpensesForTrip(tripId);
    if (expenses.isEmpty) return 0;
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Get total for a specific category within a trip
  double getCategoryTotal(String tripId, ExpenseCategory category) {
    final expenses = getExpensesForTrip(tripId);
    final categoryExpenses = expenses
        .where((e) => e.category == category)
        .toList();
    if (categoryExpenses.isEmpty) return 0;
    return categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Add a new expense
  void addExpense({
    required String tripId,
    required ExpenseCategory category,
    required double amount,
    String? note,
  }) {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tripId: tripId,
      category: category,
      amount: amount,
      note: note,
      createdAt: DateTime.now(),
    );

    if (_expensesByTrip.containsKey(tripId)) {
      _expensesByTrip[tripId]!.add(expense);
    } else {
      _expensesByTrip[tripId] = [expense];
    }
    _expensesByTrip.refresh();
  }

  /// Delete an expense
  void deleteExpense(String tripId, String expenseId) {
    if (_expensesByTrip.containsKey(tripId)) {
      _expensesByTrip[tripId]!.removeWhere((e) => e.id == expenseId);
      _expensesByTrip.refresh();
    }
  }
}
