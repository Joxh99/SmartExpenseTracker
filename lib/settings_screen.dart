import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;
  String selectedCurrency = 'USD';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load settings on screen load
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _updateTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkTheme = value;
      prefs.setBool('isDarkTheme', value);
    });
  }

  Future<void> _changeCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = currency;
      prefs.setString('selectedCurrency', currency);
    });
  }

  Future<void> _toggleLoginLogout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = !isLoggedIn;
      prefs.setBool('isLoggedIn', isLoggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dark Theme Toggle
            SwitchListTile(
              title: Text('Dark Theme'),
              value: isDarkTheme,
              onChanged: (bool value) {
                _updateTheme(value);
              },
            ),

            // Currency Changer Dropdown
            ListTile(
              title: Text('Currency'),
              subtitle: DropdownButton<String>(
                value: selectedCurrency,
                items: ['USD', 'EUR', 'INR']
                    .map((currency) => DropdownMenuItem(
                  child: Text(currency),
                  value: currency,
                ))
                    .toList(),
                onChanged: (newValue) {
                  _changeCurrency(newValue!);
                },
              ),
            ),

            // Login/Logout button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleLoginLogout,
              child: Text(isLoggedIn ? 'Logout' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}

