class HabitInfo {
  final String name;
  final String requirement;
  final int streak;
  final int completed;
  final int failed;
  final int excused;
  final HabitDate startDate;
  final HabitDate? endDate;

  HabitInfo({
    required this.name,
    required this.requirement,
    required this.streak,
    required this.completed,
    required this.failed,
    required this.excused,
    required this.startDate,
    required this.endDate,
  });
}

class HabitDate {
  final int year;
  final int month;
  final int date;

  HabitDate(this.year, this.month, this.date);
}
