import 'package:flutter/material.dart';
import 'expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) addExpense;

  AddExpenseScreen({required this.addExpense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Food';

  void _submitData() {
    final title = titleController.text;
    final amount = double.tryParse(amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0) return;

    final newExpense = Expense(
      title: title,
      amount: amount,
      category: selectedCategory,
      date: DateTime.now().toIso8601String(),
    );

    widget.addExpense(newExpense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: [
                'Food',
                'Transport',
                'Utilities',
                'Entertainment',
                'Holiday',
                'Medical',
                'Shopping',
                'Misc'
              ].map((category) => DropdownMenuItem(
                child: Text(category),
                value: category,
              ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}