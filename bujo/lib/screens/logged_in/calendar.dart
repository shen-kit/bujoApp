import 'package:flutter/material.dart';

import 'package:bujo/shared/screen_base.dart';

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
          child: Column(
              // children: [],
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
