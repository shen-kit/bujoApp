import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/habit.dart';
import 'package:flutter/material.dart';

import 'package:bujo/shared/screen_base.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        context: context,
        title: 'Habits',
        subtitle: 'Every action is a vote for who you will become',
        settings: true,
        mainContent: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                'Current',
                style: headerStyle,
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Chinese',
                  requirement: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Cold Shower',
                  requirement: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Morning Exercise',
                  requirement: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Afternoon Exercise',
                  requirement: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Finished',
                style: headerStyle,
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'No Artificial Sugar',
                  requirement: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
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

class HabitCard extends StatelessWidget {
  const HabitCard({
    Key? key,
    required this.habit,
  }) : super(key: key);

  final HabitInfo habit;

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
              width: (MediaQuery.of(context).size.width - 60) * 3 / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    habit.requirement,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) * 1 / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        habit.streak.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        FontAwesomeIcons.fire,
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (habit.completed /
                                (habit.completed + habit.failed) *
                                100)
                            .toString()
                            .substring(0, 4),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        FontAwesomeIcons.percent,
                        size: 12,
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
