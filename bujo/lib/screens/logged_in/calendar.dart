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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenBase(
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
                events: [
                  EventInfo(
                    name: 'Squash w/ Reuben',
                    startTime: EventTime(2021, 12, 19, 14, 0),
                    endTime: EventTime(2021, 12, 19, 16, 0),
                    location: 'Leeming Striker',
                  ),
                  EventInfo(
                    name: 'Carols in the Park',
                    startTime: EventTime(2021, 12, 19, 18, 30),
                    endTime: EventTime(2021, 12, 19, 19, 30),
                    location: 'Gemmell Park',
                  ),
                ],
              ),
              DateEvents(
                date: '20/12',
                day: 'Mon',
                events: [
                  EventInfo(
                    name: 'Spiderman w/ Khush/Sy/Jere',
                    startTime: EventTime(2021, 12, 19, 14, 0),
                    endTime: EventTime(2021, 12, 19, 16, 0),
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
        onPressed: () {},
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
    required this.events,
  }) : super(key: key);

  final String date;
  final String day;
  final List<EventInfo> events;

  List<EventCard> _generateEventCards() {
    return events.map((event) => EventCard(event: event)).toList();
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
  }) : super(key: key);

  final EventInfo event;

  String _formatEventTime(EventTime time) {
    bool am = time.hour <= 12;
    String hour = am ? time.hour.toString() : (time.hour - 12).toString();
    String minute =
        time.minute == 0 ? '' : time.minute.toString().padRight(2, '0');
    return '$hour${minute == '' ? '' : ':$minute'}${am ? 'am' : 'pm'}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () {},
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
                          '${_formatEventTime(event.startTime)}-${_formatEventTime(event.endTime)}',
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
