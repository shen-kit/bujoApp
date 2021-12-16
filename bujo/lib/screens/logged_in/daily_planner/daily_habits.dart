import 'package:flutter/material.dart';

class DailyHabits extends StatefulWidget {
  const DailyHabits({Key? key}) : super(key: key);

  @override
  _DailyHabitsState createState() => _DailyHabitsState();
}

class _DailyHabitsState extends State<DailyHabits> {
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
