import 'package:bujo/shared/bottom_bar.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/event.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DailyEvents extends StatefulWidget {
  const DailyEvents({Key? key}) : super(key: key);

  @override
  _DailyEventsState createState() => _DailyEventsState();
}

class _DailyEventsState extends State<DailyEvents> {
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
      backgroundColor: const Color(0xff000C35),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, i) {
          return EventCard(
            event: EventInfo(
              name: 'My Party',
              date: EventDate(year: 2021, month: 12, date: 22),
              startTime: EventTime(16, 0),
              endTime: EventTime(20, 30),
              location: 'Home',
            ),
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
    return TextButton(
      onPressed: () {},
      onLongPress: () => showEditPanel(event: event),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.zero,
        backgroundColor: const Color(0x38ffffff),
        fixedSize: const Size(double.infinity, 55),
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
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    eventTimeToString(event),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
