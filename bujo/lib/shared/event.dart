class EventInfo {
  final String name;
  final EventTime startTime;
  final EventTime endTime;
  final String location;

  EventInfo({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
  });
}

class EventTime {
  final int year;
  final int month;
  final int date;
  final int hour;
  final int minute;

  EventTime(this.year, this.month, this.date, this.hour, this.minute);
}
