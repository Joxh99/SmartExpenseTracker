class RecurringExpense {
  String title;
  double amount;
  String category;
  DateTime startDate; // Keep as DateTime in Dart
  final String frequency;
  final DateTime nextDate; // Ensure nextDate is defined

  RecurringExpense({
    required this.title,
    required this.amount,
    required this.category,
    required this.startDate,
    required this.frequency,
    required this.nextDate, // Ensure this parameter is included
  });

  // Convert RecurringExpense to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'startDate': startDate.toIso8601String(), // Store as ISO string in the database
      'frequency': frequency,
      'nextDate': nextDate.toIso8601String(), // Include nextDate
    };
  }

  // Factory method to create RecurringExpense from a map
  factory RecurringExpense.fromMap(Map<String, dynamic> map) {
    return RecurringExpense(
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      startDate: DateTime.parse(map['startDate']), // Convert back to DateTime from ISO string
      frequency: map['frequency'],
      nextDate: DateTime.parse(map['nextDate']), // Convert back to DateTime for nextDate
    );
  }

  // Method to generate future dates based on the frequency
  List<DateTime> generateFutureDates({required DateTime endDate}) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate)) {
      dates.add(currentDate);

      // Update currentDate based on frequency
      if (frequency == 'Daily') {
        currentDate = currentDate.add(Duration(days: 1));
      } else if (frequency == 'Weekly') {
        currentDate = currentDate.add(Duration(days: 7));
      } else if (frequency == 'Monthly') {
        currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
      } else if (frequency == 'Yearly') {
        currentDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
      }
    }

    return dates;
  }
}
