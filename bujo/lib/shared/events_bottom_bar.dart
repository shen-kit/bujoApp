import 'package:bujo/services/database.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsBottomEditBar extends StatefulWidget {
  const EventsBottomEditBar({this.event, Key? key}) : super(key: key);

  final EventInfo? event;

  @override
  _EventsBottomEditBarState createState() => _EventsBottomEditBarState(event);
}

class _EventsBottomEditBarState extends State<EventsBottomEditBar> {
  _EventsBottomEditBarState(this.event);

  final _formKey = GlobalKey<FormState>();

  final EventInfo? event;

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DateTime date = DateTime.now();
  String dateString = DateFormat('EEE, d MMM y').format(DateTime.now());
  EventTime startTime = EventTime(0, 0);
  EventTime endTime = EventTime(0, 0);

  @override
  void initState() {
    super.initState();
    eventNameController.text = event != null ? event!.name : '';
    locationController.text = event != null ? event!.location : '';

    if (event != null) {
      date = DateTime(event!.date.year, event!.date.month, event!.date.date);
      dateString = DateFormat('EEE, d MMM y').format(date);
      startTime = event!.startTime;
      endTime = event!.endTime;
    }
  }

  Future<EventTime?> _getTime(TimeOfDay initialTime) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return timeOfDay == null
        ? null
        : EventTime(timeOfDay.hour, timeOfDay.minute);
  }

  Future<DateTime?> _getDate(DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2500),
    );
  }

  String _stringFromDate(DateTime date) =>
      DateFormat('EEE, d MMM y').format(date);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event == null ? 'New Event' : 'Edit Event',
            style: headerStyle,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: eventNameController,
            validator: (val) => val!.isEmpty ? 'Name can\'t be empty' : null,
            decoration: textInputDecoration.copyWith(labelText: 'Event name'),
            style: textInputStyle,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: locationController,
            decoration: textInputDecoration.copyWith(labelText: 'Location'),
            style: textInputStyle,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  date = await _getDate(event != null
                          ? DateTime(event!.date.year, event!.date.month,
                              event!.date.date)
                          : DateTime.now()) ??
                      date;
                  setState(() {
                    dateString = _stringFromDate(date);
                  });
                },
                child: Text(dateString),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      startTime = await _getTime(event != null
                              ? TimeOfDay(
                                  hour: event!.startTime.hour,
                                  minute: event!.startTime.minute)
                              : const TimeOfDay(hour: 0, minute: 0)) ??
                          startTime;
                      setState(() {});
                    },
                    child: Text(formatEventTime(startTime)),
                  ),
                  const Text('–'),
                  TextButton(
                    onPressed: () async {
                      endTime = await _getTime(event != null
                              ? TimeOfDay(
                                  hour: event!.endTime.hour,
                                  minute: event!.endTime.minute)
                              : const TimeOfDay(hour: 0, minute: 0)) ??
                          endTime;
                      setState(() {});
                    },
                    child: Text(formatEventTime(endTime)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                await DatabaseService().addEvent(
                  EventInfo(
                    name: eventNameController.text,
                    date: EventDate(
                      year: date.year,
                      month: date.month,
                      date: date.day,
                    ),
                    startTime: startTime,
                    endTime: endTime,
                    location: locationController.text,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
