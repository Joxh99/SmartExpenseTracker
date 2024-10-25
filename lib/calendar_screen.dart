import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'expense.dart';
import 'recurring_expense.dart';
import 'database_helper.dart'; // Ensure you have the database helper for retrieving recurring expenses

class CalendarScreen extends StatefulWidget {
  final List<Expense> expenses;

  CalendarScreen({required this.expenses});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime selectedDay;
  late DateTime focusedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Expense>> calendarEvents = {};

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    _generateCalendarEvents();
    _loadRecurringExpenses();
  }

  // Load recurring expenses from the database and add them to the calendar events
  Future<void> _loadRecurringExpenses() async {
    List<RecurringExpense> recurringExpenses = await DatabaseHelper.instance.getRecurringExpenses();

    for (var recurringExpense in recurringExpenses) {
      List<DateTime> recurringDates = _generateRecurringDates(
        startDate: recurringExpense.startDate,
        frequency: recurringExpense.frequency,
      );

      for (var date in recurringDates) {
        if (!calendarEvents.containsKey(date)) {
          calendarEvents[date] = [];
        }
        calendarEvents[date]!.add(Expense(
          title: recurringExpense.title,
          amount: recurringExpense.amount,
          category: recurringExpense.category,
          date: date.toIso8601String(),
        ));
      }
    }

    setState(() {}); // Update UI to reflect changes
  }

  // Generate future dates for recurring expenses based on the frequency
  List<DateTime> _generateRecurringDates({
    required DateTime startDate,
    required String frequency,
  }) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(DateTime.now().add(Duration(days: 365)))) {
      dates.add(currentDate);
      if (frequency == 'Weekly') {
        currentDate = currentDate.add(Duration(days: 7));
      } else if (frequency == 'Monthly') {
        currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
      } else if (frequency == 'Yearly') {
        currentDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
      }
    }

    return dates;
  }

  // Generate calendar events based on regular expenses
  void _generateCalendarEvents() {
    calendarEvents.clear(); // Clear previous events
    for (var expense in widget.expenses) {
      DateTime date = DateTime.parse(expense.date);
      if (!calendarEvents.containsKey(date)) {
        calendarEvents[date] = [];
      }
      calendarEvents[date]!.add(expense);
    }
  }

  List<Expense> _getEventsForDay(DateTime day) {
    return calendarEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _getEventsForDay(selectedDay).isEmpty
                ? Center(child: Text('No expenses for this day.'))
                : ListView.builder(
              itemCount: _getEventsForDay(selectedDay).length,
              itemBuilder: (context, index) {
                final expense = _getEventsForDay(selectedDay)[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text('${expense.category} - \$${expense.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
