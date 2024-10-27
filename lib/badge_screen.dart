import 'package:flutter/material.dart';

class Badge {
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;

  Badge({
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
  });
}

class BadgeScreen extends StatelessWidget {
  final List<Badge> badges = [
    Badge(title: 'Budget Master', description: 'Mastered the budget settings', iconPath: 'assets/budget_master.png', isUnlocked: true),
    Badge(title: 'Consistent Tracker', description: 'Tracked expenses consistently', iconPath: 'assets/consistent_tracker.png', isUnlocked: false),
    Badge(title: 'Saving Star', description: 'Saved a significant amount', iconPath: 'assets/saving_star.png', isUnlocked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return GridTile(
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(badge.iconPath, fit: BoxFit.cover, color: badge.isUnlocked ? null : Colors.grey),
                ),
                Text(badge.title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(badge.description, textAlign: TextAlign.center),
              ],
            ),
            footer: badge.isUnlocked
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.lock, color: Colors.red),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}