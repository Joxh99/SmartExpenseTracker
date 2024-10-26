import 'package:hive/hive.dart';

part 'expense_adapter.g.dart'; // Reference to the generated file

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}
