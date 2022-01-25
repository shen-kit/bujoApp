import 'package:bujo/services/database.dart';
import 'package:bujo/shared/bottom_bar.dart';
import 'package:bujo/shared/event.dart';
import 'package:bujo/shared/events_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DailyEvents extends StatefulWidget {
  const DailyEvents(this.databaseService, {Key? key}) : super(key: key);

  final DatabaseService databaseService;

  @override
  _DailyEventsState createState() => _DailyEventsState();
}

class _DailyEventsState extends State<DailyEvents> {
  @override
  Widget build(BuildContext context) {
    void showEditPanel({EventInfo? event}) async {
      showBottomEditBar(
        context,
        EventsBottomEditBar(widget.databaseService, event: event),
      );
    }

    return StreamProvider<List<EventInfo>>.value(
      value: widget.databaseService.dailyEvents,
      initialData: const [],
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xff000C35),
          body: ListView.separated(
            itemCount: Provider.of<List<EventInfo>>(context).length,
            itemBuilder: (context, i) {
              return EventCard(
                widget.databaseService,
                event: Provider.of<List<EventInfo>>(context)[i],
                showEditPanel: showEditPanel,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10),
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
