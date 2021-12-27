import 'package:bujo/shared/bottom_bar.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/habit.dart';
import 'package:flutter/material.dart';

import 'package:bujo/shared/screen_base.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Habits extends StatefulWidget {
  const Habits({Key? key}) : super(key: key);

  @override
  _HabitsState createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  @override
  Widget build(BuildContext context) {
    void showEditPanel(HabitInfo? habit) {
      TextEditingController habitNameController =
          TextEditingController(text: habit != null ? habit.name : '');
      TextEditingController habitDescriptionController =
          TextEditingController(text: habit != null ? habit.description : '');

      showBottomEditBar(
        context,
        Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                habit == null ? 'New Habit' : 'Edit Habit',
                style: headerStyle,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: habitNameController,
                validator: (val) =>
                    val!.isEmpty ? 'Name can\'t be empty' : null,
                decoration: textInputDecoration.copyWith(labelText: 'Name'),
                style: textInputStyle,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: habitDescriptionController,
                validator: (val) =>
                    val!.isEmpty ? 'Description can\'t be empty' : null,
                decoration:
                    textInputDecoration.copyWith(labelText: 'Description'),
                style: textInputStyle,
              ),
              const SizedBox(height: 10),
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
                  description: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
                showEditPanel: showEditPanel,
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Cold Shower',
                  description: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
                showEditPanel: showEditPanel,
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Morning Exercise',
                  description: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
                showEditPanel: showEditPanel,
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'Afternoon Exercise',
                  description: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: null,
                ),
                showEditPanel: showEditPanel,
              ),
              const SizedBox(height: 20),
              Text(
                'Finished',
                style: headerStyle,
              ),
              HabitCard(
                habit: HabitInfo(
                  name: 'No Artificial Sugar',
                  description: 'Practice Chinese for 5 minutes',
                  streak: 13,
                  completed: 58,
                  failed: 12,
                  excused: 3,
                  startDate: HabitDate(2021, 11, 1),
                  endDate: HabitDate(2021, 12, 31),
                ),
                showEditPanel: showEditPanel,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditPanel(null),
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
    required this.showEditPanel,
  }) : super(key: key);

  final HabitInfo habit;
  final Function showEditPanel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            habit.endDate != null
                ? SlidableAction(
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    onPressed: (context) {},
                  )
                : SlidableAction(
                    icon: Icons.flag_rounded,
                    backgroundColor: Colors.red,
                    onPressed: (context) {},
                  )
          ],
        ),
        child: TextButton(
          onPressed: () {},
          onLongPress: () => showEditPanel(habit),
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(), // set border radius = 0
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
                      habit.description,
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
      ),
    );
  }
}
