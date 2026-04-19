/// Expense categories for trip spending
enum ExpenseCategory { hotel, flight, restaurant, shopping, activities }

/// Extension to add display properties to ExpenseCategory
extension ExpenseCategoryExtension on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.hotel:
        return 'Hotel';
      case ExpenseCategory.flight:
        return 'Flights';
      case ExpenseCategory.restaurant:
        return 'Restaurants';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.activities:
        return 'Activities';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.hotel:
        return '🏨';
      case ExpenseCategory.flight:
        return '✈️';
      case ExpenseCategory.restaurant:
        return '🍽️';
      case ExpenseCategory.shopping:
        return '🛍️';
      case ExpenseCategory.activities:
        return '🎯';
    }
  }
}

/// Model representing a single expense entry
class Expense {
  final String id;
  final String tripId;
  final ExpenseCategory category;
  final double amount;
  final String? note;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.tripId,
    required this.category,
    required this.amount,
    this.note,
    required this.createdAt,
  });
}
