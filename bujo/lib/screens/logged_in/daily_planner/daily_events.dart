import 'package:flutter/material.dart';

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
