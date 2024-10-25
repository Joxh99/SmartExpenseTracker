import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized

  final database = await openDatabase(
    join(await getDatabasesPath(), 'expenses.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE expenses(id INTEGER PRIMARY KEY, title TEXT, category TEXT, amount REAL, date TEXT)',
      );
    },
    version: 1,
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  final selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';

  runApp(MyApp(
    database: database,
    isDarkTheme: isDarkTheme,
    selectedCurrency: selectedCurrency,
  ));
}

class MyApp extends StatefulWidget {
  final Database database;
  final bool isDarkTheme;
  final String selectedCurrency;

  MyApp({required this.database, required this.isDarkTheme, required this.selectedCurrency});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkTheme;
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
    _selectedCurrency = widget.selectedCurrency;
  }

  void _updateTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
    });
  }

  void _changeCurrency(String newCurrency) {
    setState(() {
      _selectedCurrency = newCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Accountant',
      theme: ThemeData.light(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          color: Colors.black,
          elevation: 0,
        ),
        colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.blueGrey,
        ),
      ),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        database: widget.database,
        updateTheme: _updateTheme,
        selectedCurrency: _selectedCurrency,
      ),
      routes: {
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}