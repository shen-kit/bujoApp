import 'package:bujo/services/database.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsBottomEditBar extends StatefulWidget {
  const EventsBottomEditBar(this.databaseService, {this.event, Key? key})
      : super(key: key);

  final EventInfo? event;
  final DatabaseService databaseService;

  @override
  _EventsBottomEditBarState createState() => _EventsBottomEditBarState();
}

class _EventsBottomEditBarState extends State<EventsBottomEditBar> {
  _EventsBottomEditBarState();

  final _formKey = GlobalKey<FormState>();

  EventInfo? event;

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DateTime date = DateTime.now();
  String dateString = '';

  bool fullDay = false;
  EventTime startTime = EventTime(0, 0);
  EventTime endTime = EventTime(0, 0);

  @override
  void initState() {
    super.initState();
    event = widget.event;
    eventNameController.text = event != null ? event!.name : '';
    locationController.text = event != null ? event!.location : '';

    date = date.add(Duration(days: widget.databaseService.dateOffset));
    dateString = _stringFromDate(date);

    if (event != null) {
      date = DateTime(event!.date.year, event!.date.month, event!.date.date);
      dateString = _stringFromDate(date);
      startTime = event!.startTime;
      endTime = event!.endTime;
      fullDay = event!.fullDay;
    }
  }

  Future<List<EventTime>?> _getTime(
      TimeOfDay initialStartTime, TimeOfDay initialEndTime) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: initialStartTime,
      helpText: 'Choose Start Time',
    );
    if (startTime == null) return null;
    TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: initialEndTime,
      helpText: 'Choose End Time',
    );

    return endTime == null
        ? null
        : [
            EventTime(startTime.hour, startTime.minute),
            EventTime(endTime.hour, endTime.minute),
          ];
  }

  Future<DateTime?> _getDate(DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2500),
    );
  }

  String _stringFromDate(DateTime _date) =>
      DateFormat('EEE, d MMM y').format(_date);

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
          // date picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  date = await _getDate(date) ?? date;
                  setState(() {
                    dateString = _stringFromDate(date);
                  });
                },
                child: Text(dateString),
              ),
              Row(
                children: [
                  const Text('Full Day'),
                  Checkbox(
                    value: fullDay,
                    checkColor: Colors.black,
                    onChanged: (value) {
                      setState(() => fullDay = !fullDay);
                    },
                  ),
                ],
              ),
            ],
          ),
          // time picker
          !fullDay
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      // get new times from picker, auto fill current details if any
                      // continue with current times if 'cancel' pressed
                      List<EventTime>? times = await _getTime(
                              TimeOfDay(
                                hour: startTime.hour,
                                minute: startTime.minute,
                              ),
                              TimeOfDay(
                                hour: endTime.hour,
                                minute: endTime.minute,
                              )) ??
                          [startTime, endTime];
                      setState(() {
                        startTime = times[0];
                        endTime = times[1];
                      });
                    },
                    child: Text(
                        '${formatEventTime(startTime)} – ${formatEventTime(endTime)}'),
                  ),
                )
              // maintain height
              : const TextButton(onPressed: null, child: Text(' ')),
          // save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                EventInfo newEventInfo = EventInfo(
                  docId: event?.docId,
                  name: eventNameController.text,
                  date: EventDate(
                    year: date.year,
                    month: date.month,
                    date: date.day,
                  ),
                  fullDay: fullDay,
                  startTime: startTime,
                  endTime: endTime,
                  location: locationController.text,
                );

                // new event
                if (event == null) {
                  await widget.databaseService.addEvent(newEventInfo);
                } else {
                  await widget.databaseService.updateEvent(newEventInfo);
                }

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
