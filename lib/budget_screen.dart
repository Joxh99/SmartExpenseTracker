import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final Function(double) setBudget;

  const BudgetScreen({Key? key, required this.setBudget}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _budgetController,
              decoration: InputDecoration(
                labelText: 'Enter Budget Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double budget = double.tryParse(_budgetController.text) ?? 0.0;
                widget.setBudget(budget);
                Navigator.of(context).pop();
              },
              child: Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}

