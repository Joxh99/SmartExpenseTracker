import 'package:hive/hive.dart';
part 'recurring_expense_adapter.g.dart'; // Reference to the generated file

@HiveType(typeId: 2)
class RecurringExpense {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final String frequency; // e.g., daily, weekly, monthly

  RecurringExpense({
    required this.title,
    required this.amount,
    required this.category,
    required this.startDate,
    required this.frequency,
  });
}
