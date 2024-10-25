import 'package:flutter/material.dart';
import 'database_helper.dart'; // SQLite helper for database interactions
import 'recurring_expense.dart';

class RecurringExpenseScreen extends StatefulWidget {
  final Function addRecurringExpense;

  const RecurringExpenseScreen({super.key, required this.addRecurringExpense});

  @override
  _RecurringExpenseScreenState createState() => _RecurringExpenseScreenState();
}

class _RecurringExpenseScreenState extends State<RecurringExpenseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Food';
  String selectedFrequency = 'Monthly';
  DateTime selectedStartDate = DateTime.now();

  Future<void> _submitRecurringExpense() async {
    final String title = titleController.text;
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    print('Submitting Recurring Expense: $title, $amount');

    if (title.isNotEmpty && amount > 0) {
      try {
        final newRecurringExpense = RecurringExpense(
          title: title,
          amount: amount,
          category: selectedCategory,
          startDate: selectedStartDate,
          frequency: selectedFrequency,
          nextDate: _getNextDate(selectedStartDate, selectedFrequency), // Calculate nextDate
        );

        await DatabaseHelper.instance.insertRecurringExpense(newRecurringExpense);
        widget.addRecurringExpense(newRecurringExpense); // Add to in-memory list
        print('Recurring Expense Added Successfully');
        Navigator.of(context).pop(); // Close the screen after submission
      } catch (e) {
        print('Failed to add recurring expense: $e');
        // Optionally, you could show a dialog here instead of just printing to console
      }
    } else {
      print('Title or Amount not valid');
    }
  }

  // Method to calculate the next date based on frequency
  DateTime _getNextDate(DateTime date, String frequency) {
    switch (frequency) {
      case 'Weekly':
        return date.add(Duration(days: 7));
      case 'Monthly':
        return DateTime(date.year, date.month + 1, date.day);
      case 'Yearly':
        return DateTime(date.year + 1, date.month, date.day);
      default:
        return date; // Default case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recurring Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: ['Food', 'Transport', 'Utilities', 'Entertainment', 'Medical']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedFrequency,
              items: ['Weekly', 'Monthly', 'Yearly'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFrequency = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitRecurringExpense,
              child: Text('Add Recurring Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
