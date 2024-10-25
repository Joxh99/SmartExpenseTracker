import 'package:hive/hive.dart';
part 'challenge_adapter.g.dart'; // Reference to the generated file

@HiveType(typeId: 1)
class Challenge {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double goalAmount;

  @HiveField(2)
  double progress;

  @HiveField(3)
  bool isCompleted;

  Challenge({
    required this.category,
    required this.goalAmount,
    this.progress = 0.0,
    this.isCompleted = false,
  });
}
