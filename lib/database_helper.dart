import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'expense.dart';
import 'recurring_expense.dart';
import 'challenge.dart';

class DatabaseHelper {
  static final _databaseName = 'accountant.db';
  static final _databaseVersion = 1;

  static final tableExpenses = 'expenses';
  static final tableRecurringExpenses = 'recurring_expenses';
  static final tableChallenges = 'challenges';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Create expenses table
    await db.execute('''
      CREATE TABLE $tableExpenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // Create recurring expenses table
    await db.execute('''
      CREATE TABLE $tableRecurringExpenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        startDate TEXT NOT NULL,
        frequency TEXT NOT NULL,
        nextDate TEXT NOT NULL
      )
    ''');

    // Create challenges table
    await db.execute('''
      CREATE TABLE $tableChallenges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        goalAmount REAL NOT NULL,
        progress REAL NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // Insert new expense
  Future<int> insertExpense(Expense expense) async {
    Database db = await instance.database;
    return await db.insert(tableExpenses, expense.toMap());
  }

  // Get all expenses
  Future<List<Expense>> getExpenses() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableExpenses);
    return List.generate(maps.length, (i) {
      return Expense(
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        date: DateTime.parse(maps[i]['date']).toString(),
      );
    });
  }

  // Insert recurring expense
  Future<int> insertRecurringExpense(RecurringExpense recurringExpense) async {
    Database db = await instance.database;
    return await db.insert(tableRecurringExpenses, recurringExpense.toMap());
  }

  // Get all recurring expenses with null handling
  Future<List<RecurringExpense>> getRecurringExpenses() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableRecurringExpenses);
    return List.generate(maps.length, (i) {
      return RecurringExpense(
        title: maps[i]['title'] ?? '', // Default to empty string if null
        amount: maps[i]['amount'] ?? 0.0, // Default to 0.0 if null
        category: maps[i]['category'] ?? '', // Default to empty string if null
        startDate: maps[i]['startDate'] != null ? DateTime.parse(maps[i]['startDate']) : DateTime.now(), // Default to current date if null
        frequency: maps[i]['frequency'] ?? '', // Default to empty string if null
        nextDate: maps[i]['nextDate'] != null ? DateTime.parse(maps[i]['nextDate']) : DateTime.now(), // Default to current date if null
      );
    });
  }

  // Convert recurring expenses to future expenses
  Future<List<Expense>> getRecurringExpensesAsExpenses(DateTime endDate) async {
    final List<RecurringExpense> recurringExpenses = await getRecurringExpenses();
    List<Expense> futureExpenses = [];

    for (var recurring in recurringExpenses) {
      DateTime startDate = recurring.startDate;
      DateTime currentDate = startDate;

      while (currentDate.isBefore(endDate)) {
        futureExpenses.add(Expense(
          title: recurring.title,
          amount: recurring.amount,
          category: recurring.category,
          date: currentDate.toIso8601String(),
        ));

        if (recurring.frequency == 'Daily') {
          currentDate = currentDate.add(Duration(days: 1));
        } else if (recurring.frequency == 'Weekly') {
          currentDate = currentDate.add(Duration(days: 7));
        } else if (recurring.frequency == 'Monthly') {
          currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
        } else if (recurring.frequency == 'Yearly') {
          currentDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
        }
      }
    }

    return futureExpenses;
  }

  // Insert challenge
  Future<int> insertChallenge(Challenge challenge) async {
    Database db = await instance.database;
    return await db.insert(tableChallenges, challenge.toMap());
  }

  // Get all challenges
  Future<List<Challenge>> getChallenges() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableChallenges);
    return List.generate(maps.length, (i) {
      return Challenge(
        category: maps[i]['category'],
        goalAmount: maps[i]['goalAmount'],
        progress: maps[i]['progress'],
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });
  }
}
