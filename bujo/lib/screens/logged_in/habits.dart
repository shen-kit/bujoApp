import 'package:flutter/material.dart';

import 'package:bujo/shared/screen_base.dart';

class Habits extends StatefulWidget {
  const Habits({Key? key}) : super(key: key);

  @override
  _HabitsState createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenBase(
        title: 'Habits',
        subtitle: 'Every action is a vote for who you will become',
        settings: true,
        mainContent: Column(
          children: [],
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
