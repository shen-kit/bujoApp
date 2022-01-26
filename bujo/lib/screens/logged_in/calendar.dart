import 'package:bujo/services/database.dart';
import 'package:bujo/shared/bottom_bar.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/event.dart';
import 'package:bujo/shared/events_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:bujo/shared/screen_base.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String formatDate(DateTime date) => DateFormat('EEEE, MMMM d').format(date);

  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    void showEditPanel({EventInfo? event}) async {
      showBottomEditBar(
        context,
        EventsBottomEditBar(DatabaseService(), event: event),
      );
    }

    return StreamProvider<Map<DateTime, List<EventInfo>>>.value(
      initialData: const {},
      value: databaseService.calendarEvents,
      builder: (context, child) {
        Map<DateTime, List<EventInfo>> dates =
            Provider.of<Map<DateTime, List<EventInfo>>>(context);

        return Scaffold(
          body: screenBase(
            context: context,
            title: 'Calendar',
            subtitle: DateFormat('EEEE, d MMMM y').format(DateTime.now()),
            settings: true,
            mainContent: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: dates.length + 1,
                itemBuilder: (context, i) {
                  return (i < dates.length)
                      ? DateEvents(
                          databaseService,
                          date: dates.keys.elementAt(i),
                          showEditPanel: showEditPanel,
                          events: dates[dates.keys.elementAt(i)]!,
                        )
                      : TextButton(
                          onPressed: () => setState(
                              () => databaseService.loadMoreCalendarEvents()),
                          child: const Text(
                            'Load More',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                            ),
                          ),
                        );
                },
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
      },
    );
  }
}

class DateEvents extends StatelessWidget {
  const DateEvents(
    this.databaseService, {
    Key? key,
    required this.date,
    required this.showEditPanel,
    required this.events,
  }) : super(key: key);

  final DatabaseService databaseService;
  final DateTime date;
  final List<EventInfo> events;
  final Function showEditPanel;

  List<EventCard> _generateEventCards() {
    return events
        .map((event) => EventCard(
              databaseService,
              event: event,
              showEditPanel: showEditPanel,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String dateText = DateFormat('d/MM | EEE').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateText,
          style: headerStyle,
        ),
        ..._generateEventCards(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard(
    this.databaseService, {
    Key? key,
    required this.event,
    required this.showEditPanel,
  }) : super(key: key);

  final EventInfo event;
  final Function showEditPanel;
  final DatabaseService databaseService;

  List<Widget> timeLocationWidgets() {
    if (event.fullDay && event.location.isEmpty) return [];
    if (event.fullDay) {
      return [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.location,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.location_on,
                size: 16,
              ),
            ],
          ),
        ),
      ];
    }
    if (event.location.isEmpty) {
      return [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stringFromEventTime(event),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 5),
              const Icon(
                FontAwesomeIcons.solidClock,
                size: 16,
              )
            ],
          ),
        ),
      ];
    }
    return [
      Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.location,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.location_on,
              size: 16,
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stringFromEventTime(event),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 5),
            const Icon(
              FontAwesomeIcons.solidClock,
              size: 16,
            )
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.only(top: 10),
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (context) => databaseService.deleteEvent(event.docId),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {},
          onLongPress: () => showEditPanel(event: event),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: const Color(0x38ffffff),
            shape: const RoundedRectangleBorder(), // set border radius = 0
          ),
          child: Container(
            width: double.infinity,
            height: 57,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) * (3 / 5),
                    child: Text(
                      event.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                ...timeLocationWidgets(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
