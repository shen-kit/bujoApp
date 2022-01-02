class EventInfo {
  final String name;
  final EventDate date;
  final EventTime startTime;
  final EventTime endTime;
  final String location;

  EventInfo({
    required this.name,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
  });
}

class EventDate {
  final int year;
  final int month;
  final int date;

  EventDate({required this.year, required this.month, required this.date});
}

class EventTime {
  final int hour;
  final int minute;

  EventTime(this.hour, this.minute);
}

String formatEventTime(EventTime time, {bool suffix = true}) {
  bool am = time.hour <= 12;
  String hour = am ? time.hour.toString() : (time.hour - 12).toString();
  if (hour == '0') hour = '12';
  String minute =
      time.minute == 0 ? '' : time.minute.toString().padRight(2, '0');
  return '$hour${minute == '' ? '' : ':$minute'}${suffix ? am ? 'am' : 'pm' : ''}';
}

String stringFromEventTime(EventInfo event) {
  // before 12 = 0, after 12 = 1
  bool bothAmOrPm =
      (event.startTime.hour / 12).floor() == (event.endTime.hour / 12).floor();
  String startTime = formatEventTime(event.startTime, suffix: !bothAmOrPm);
  String endTime = formatEventTime(event.endTime);
  return '$startTime-$endTime';
}

DateTime dateTimeFromEventTime(EventDate date, EventTime time) =>
    DateTime(date.year, date.month, date.date, time.hour, time.minute);
