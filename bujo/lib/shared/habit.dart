class HabitInfo {
  final String? docId;
  final String name;
  final String description;
  final String partialRequirement;
  final int? streak;
  final int completed;
  final int partiallyCompleted;
  final int failed;
  final int excused;
  final DateTime startDate;
  final DateTime? endDate;
  final int order;

  HabitInfo({
    this.docId,
    required this.name,
    required this.description,
    required this.partialRequirement,
    this.streak,
    required this.completed,
    required this.partiallyCompleted,
    required this.failed,
    required this.excused,
    required this.startDate,
    required this.endDate,
    required this.order,
  });
}

class HabitCompletionInfo {
  final String? docId;
  final String name;
  final String status;

  HabitCompletionInfo({
    this.docId,
    required this.name,
    required this.status,
  });
}
