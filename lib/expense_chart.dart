import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;
  final Map<String, double> categoryTotals;

  ExpenseChart({
    required this.expenses,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    double totalExpense = categoryTotals.values.fold(0, (sum, amount) => sum + amount);

    List<BarChartGroupData> getBarGroups() {
      return categoryTotals.entries.map((entry) {
        final category = entry.key;
        final totalAmount = entry.value;

        return BarChartGroupData(
          x: category.hashCode, // Use the category as an identifier
          barRods: [
            BarChartRodData(
              y: totalAmount, // For older versions of fl_chart
              colors: [getCategoryColor(category)],
              width: 35,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense by Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Bar chart section
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: getBarGroups(),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: false, // Hide left axis titles
                    ),
                    bottomTitles: SideTitles(
                      showTitles: false,
                      getTitles: (value) {
                        // Convert hashcode back to category name
                        return categoryTotals.keys
                            .firstWhere((category) => category.hashCode == value, orElse: () => '');
                      },
                      rotateAngle: 0, // No rotation for titles
                      interval: 1, // Display all labels
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Total Expense box
            Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.lime,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Total Expense = \$${totalExpense.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Table of categories and their expenses
            Table(
              border: TableBorder.all(color: Colors.white), // Adds borders to the table cells
              children: categoryTotals.entries.map((entry) {
                return TableRow(
                  children: [
                    Container(
                      color: Colors.lime,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry.key, // Category name
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '\$${entry.value.toStringAsFixed(2)}', // Total expense for the category
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get color for each category
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Transport':
        return Colors.green;
      case 'Utilities':
        return Colors.orange;
      case 'Entertainment':
        return Colors.purple;
      case 'Medical':
        return Colors.red;
      case 'Shopping':
        return Colors.pink;
      case 'Holiday':
        return Colors.brown;
      case 'Other':
      default:
        return Colors.black;
    }
  }
}
