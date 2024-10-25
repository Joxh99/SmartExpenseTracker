class Challenge {
  String category;
  double goalAmount;
  double progress;
  bool isCompleted;

  Challenge({
    required this.category,
    required this.goalAmount,
    required this.progress,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'goalAmount': goalAmount,
      'progress': progress,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
