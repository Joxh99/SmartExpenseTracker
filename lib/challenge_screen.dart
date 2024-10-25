import 'package:flutter/material.dart';
import 'challenge.dart';
import 'database_helper.dart';

class ChallengeScreen extends StatefulWidget {
  final Function addChallenge;

  const ChallengeScreen({Key? key, required this.addChallenge}) : super(key: key);

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController goalAmountController = TextEditingController();
  double progress = 0.0;
  bool isCompleted = false;

  Future<void> _submitChallenge() async {
    final String category = categoryController.text;
    final double goalAmount = double.tryParse(goalAmountController.text) ?? 0.0;

    if (category.isNotEmpty && goalAmount > 0) {
      Challenge newChallenge = Challenge(
        category: category,
        goalAmount: goalAmount,
        progress: progress,
        isCompleted: isCompleted,
      );

      // Insert the challenge into the database
      await DatabaseHelper.instance.insertChallenge(newChallenge);
      widget.addChallenge(newChallenge); // Add to in-memory list
      Navigator.of(context).pop(); // Close the screen after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Challenge Category'),
            ),
            TextField(
              controller: goalAmountController,
              decoration: const InputDecoration(labelText: 'Goal Amount'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _submitChallenge,
              child: const Text('Add Challenge'),
            ),
          ],
        ),
      ),
    );
  }
}
