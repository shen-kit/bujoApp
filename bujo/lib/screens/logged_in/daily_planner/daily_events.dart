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
    return Scaffold(
      backgroundColor: const Color(0xff000C35),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, i) {
          return const EventCard(
            eventName: 'My Party',
            time: '4-8pm',
            location: 'Home',
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
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

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.eventName,
    required this.time,
    required this.location,
  }) : super(key: key);

  final String eventName;
  final String time;
  final String location;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
                  eventName,
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
                    time,
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
                    location,
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
