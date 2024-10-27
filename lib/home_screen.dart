import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'add_expense_screen.dart';
import 'expense_chart.dart';
import 'calendar_screen.dart';
import 'recurring_expense_screen.dart';
import 'challenge_screen.dart';
import 'settings_screen.dart';
import 'expense.dart';
import 'recurring_expense.dart';
import 'challenge.dart';
import 'database_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'badge_screen.dart';

class HomeScreen extends StatefulWidget {
  final Database database;
  final Function(bool) updateTheme;
  final String selectedCurrency;

  HomeScreen({
    required this.database,
    required this.updateTheme,
    required this.selectedCurrency,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  List<RecurringExpense> recurringExpenses = [];
  DateTimeRange? selectedDateRange;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _loadRecurringExpenses();
  }

  Future<void> _loadExpenses() async {
    final List<Map<String, dynamic>> maps = await widget.database.query('expenses');
    setState(() {
      expenses = maps.map((map) => Expense.fromMap(map)).toList();
    });
  }

  Future<void> _loadRecurringExpenses() async {
    List<RecurringExpense> recurringExpensesList = await DatabaseHelper.instance.getRecurringExpenses();
    setState(() {
      recurringExpenses = recurringExpensesList;
    });
  }

  List<Expense> _getFilteredExpenses() {
    if (selectedCategory == 'All') {
      return expenses;
    } else {
      return expenses.where((expense) => expense.category == selectedCategory).toList();
    }
  }

  Map<String, double> _getCategoryTotals(List<Expense> expenses) {
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals.update(expense.category, (existing) => existing + expense.amount, ifAbsent: () => expense.amount);
    }
    return categoryTotals;
  }

  double _getTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();
    final totalExpense = _getTotalExpenses(filteredExpenses);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Map<String, double> categoryTotals = _getCategoryTotals(filteredExpenses);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpenseChart(
                    expenses: filteredExpenses,
                    categoryTotals: categoryTotals,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CalendarScreen(expenses: filteredExpenses),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _showDownloadDialog,
          ),
          IconButton(
            icon: const Icon(Icons.badge), // Use an appropriate icon for badges
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BadgeScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF800080),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Accountant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  value: selectedCategory,
                  items: ['All', 'Food', 'Transport', 'Utilities', 'Entertainment', 'Medical', 'Shopping', 'Holiday', 'Misc']
                      .map((category) => DropdownMenuItem(
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
              ),
              Expanded(
                child: filteredExpenses.isEmpty
                    ? const Center(child: Text('No expenses added yet.'))
                    : ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return ListTile(
                      leading: Container(
                        width: 10,
                        height: 40,
                        color: _getCategoryColor(expense.category),
                      ),
                      title: Text(expense.title),
                      subtitle: Text('${expense.category} - \$${expense.amount.toStringAsFixed(2)}'),
                      trailing: Text(DateTime.parse(expense.date).toLocal().toString().split(' ')[0]),
                      onTap: () => _showEditDeleteExpenseDialog(context, expense),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.lime,
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Total Expense: \$${totalExpense.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 80, // Adjust the distance from the top
            left: 315, // Adjust the distance from the left
            child: FloatingActionButton(
              onPressed: _showAIDialog, // Open AI features dialog
              tooltip: 'AI Features',
              backgroundColor: Colors.purple,
              child: const Icon(Icons.smart_toy), // AI icon
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddExpenseScreen(addExpense: _addExpense),
                ),
              );
            },
            tooltip: 'Add Expense',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecurringExpenseScreen(addRecurringExpense: _loadRecurringExpenses),
                ),
              );
            },
            tooltip: 'Recurring Expenses',
            child: const Icon(Icons.repeat),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChallengeScreen(addChallenge: (challenge) {}),
                ),
              );
            },
            tooltip: 'Create Challenge',
            child: const Icon(Icons.flag),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.red;
      case 'Transport':
        return Colors.blue;
      case 'Utilities':
        return Colors.green;
      case 'Entertainment':
        return Colors.yellow;
      case 'Medical':
        return Colors.purple;
      case 'Shopping':
        return Colors.orange;
      case 'Holiday':
        return Colors.brown;
      default:
        return Colors.black;
    }
  }

  void _showAIDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AI Features'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.insights),
                title: const Text('AI Spending Insights'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.warning_amber_rounded),
                title: const Text('Unusual Spending Alerts'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.recommend),
                title: const Text('Spending Recommendations'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _addExpense(Expense newExpense) async {
    await widget.database.insert('expenses', newExpense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _loadExpenses();
    _showSnackBar('Expense added');
  }

  void _showEditDeleteExpenseDialog(BuildContext context, Expense expense) {
    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(text: expense.amount.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit/Delete Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedExpense = Expense(
                  id: expense.id,
                  title: titleController.text,
                  category: expense.category,
                  amount: double.parse(amountController.text),
                  date: expense.date,
                );
                _editExpense(updatedExpense);
                Navigator.of(ctx).pop();
                _showSnackBar('Expense updated');
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                _deleteExpense(expense.id!);
                Navigator.of(ctx).pop();
                _showSnackBar('Expense deleted');
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editExpense(Expense updatedExpense) async {
    await widget.database.update(
      'expenses',
      updatedExpense.toMap(),
      where: 'id = ?',
      whereArgs: [updatedExpense.id],
    );
    _loadExpenses();
    _showSnackBar('Expense updated');
  }

  void _deleteExpense(int id) async {
    await widget.database.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadExpenses();
    _showSnackBar('Expense deleted');
  }

  Future<void> _showDownloadDialog() async {
    final shouldDownload = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download PDF'),
          content: const Text('Do you want to download the expenses as a PDF?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
                _generateAndSavePDF();
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateAndSavePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Expense Report', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Title', 'Amount', 'Category', 'Date'],
                data: expenses.map((expense) {
                  return [
                    expense.title,
                    '\$${expense.amount.toStringAsFixed(2)}',
                    expense.category,
                    expense.date,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/expenses_report.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF exported to $filePath')),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
