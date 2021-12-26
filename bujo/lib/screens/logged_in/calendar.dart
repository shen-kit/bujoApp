import 'package:bujo/shared/bottom_bar.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/event.dart';
import 'package:flutter/material.dart';

import 'package:bujo/shared/screen_base.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showEditPanel({EventInfo? event}) async {
      TextEditingController eventNameController = TextEditingController(
        text: (event != null) ? event.name : '',
      );
      TextEditingController locationController = TextEditingController(
        text: (event != null) ? event.location : '',
      );

      Future<TimeOfDay?> _getTime(TimeOfDay initialTime) async =>
          showTimePicker(
            context: context,
            initialTime: initialTime,
          );

      Future<DateTime?> _getDate(DateTime initialDate) async => showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2021),
            lastDate: DateTime(2500),
          );

      String date = (event != null)
          ? '${event.date.date}/${event.date.month}/${event.date.year}'
          : 'Choose Date';
      EventTime startTime = (event != null) ? event.startTime : EventTime(0, 0);
      EventTime endTime = (event != null) ? event.endTime : EventTime(0, 0);

      showBottomEditBar(
        context,
        Form(
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
                validator: (val) =>
                    val!.isEmpty ? 'Name can\'t be empty' : null,
                decoration:
                    textInputDecoration.copyWith(labelText: 'Event name'),
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
                    onPressed: () => _getDate(event != null
                        ? DateTime(
                            event.date.year, event.date.month, event.date.date)
                        : DateTime.now()),
                    child: Text(date),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () async {
                          /*TimeOfDay? newTime =*/ await _getTime(
                            event != null
                                ? TimeOfDay(
                                    hour: event.startTime.hour,
                                    minute: event.startTime.minute)
                                : const TimeOfDay(hour: 0, minute: 0),
                          );
                        },
                        child: Text(formatEventTime(startTime)),
                      ),
                      const Text('–'),
                      TextButton(
                        onPressed: () async {
                          /* TimeOfDay? newTime =*/ await _getTime(event != null
                              ? TimeOfDay(
                                  hour: event.endTime.hour,
                                  minute: event.endTime.minute)
                              : const TimeOfDay(hour: 0, minute: 0));
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: screenBase(
        context: context,
        title: 'Calendar',
        subtitle: 'Thursday, 16th December 2021',
        settings: true,
        mainContent: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              DateEvents(
                date: '19/12',
                day: 'Sun',
                showEditPanel: showEditPanel,
                events: [
                  EventInfo(
                    name: 'Squash w/ Reuben',
                    date: EventDate(year: 2021, month: 12, date: 19),
                    startTime: EventTime(14, 0),
                    endTime: EventTime(16, 0),
                    location: 'Leeming Striker',
                  ),
                  EventInfo(
                    name: 'Carols in the Park',
                    date: EventDate(year: 2021, month: 12, date: 19),
                    startTime: EventTime(19, 0),
                    endTime: EventTime(21, 30),
                    location: 'Gemmell Park',
                  ),
                ],
              ),
              DateEvents(
                date: '20/12',
                day: 'Mon',
                showEditPanel: showEditPanel,
                events: [
                  EventInfo(
                    name: 'Spiderman w/ Khush/Sy/Jere',
                    date: EventDate(year: 2021, month: 12, date: 20),
                    startTime: EventTime(11, 15),
                    endTime: EventTime(15, 30),
                    location: 'Carousel Hoyts',
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Load More',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showEditPanel,
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
    );
  }
}

class DateEvents extends StatelessWidget {
  const DateEvents({
    Key? key,
    required this.date,
    required this.day,
    required this.showEditPanel,
    required this.events,
  }) : super(key: key);

  final String date;
  final String day;
  final List<EventInfo> events;
  final Function showEditPanel;

  List<EventCard> _generateEventCards() {
    return events
        .map((event) => EventCard(
              event: event,
              showEditPanel: showEditPanel,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$date | $day',
          style: headerStyle,
        ),
        ..._generateEventCards(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
    required this.showEditPanel,
  }) : super(key: key);

  final EventInfo event;
  final Function showEditPanel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () {},
        onLongPress: () => showEditPanel(event: event),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          backgroundColor: const Color(0x38ffffff),
          primary: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) * 11 / 20,
              child: Text(
                event.name,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                // maxLines: 2,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) * 8 / 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          eventTimeToString(event),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        FontAwesomeIcons.solidClock,
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          event.location,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
