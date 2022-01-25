import 'package:bujo/screens/logged_in/daily_planner/daily_events.dart';
import 'package:bujo/screens/logged_in/daily_planner/daily_habits.dart';
import 'package:bujo/screens/logged_in/daily_planner/daily_todo.dart';
import 'package:bujo/services/database.dart';
import 'package:bujo/shared/constants.dart';
import 'package:flutter/material.dart';

import 'package:bujo/shared/get_text_size.dart';
import 'package:bujo/shared/screen_base.dart';
import 'package:intl/intl.dart';

class DailyPlanner extends StatefulWidget {
  const DailyPlanner({Key? key}) : super(key: key);

  @override
  _DailyPlannerState createState() => _DailyPlannerState();
}

class _DailyPlannerState extends State<DailyPlanner> {
  final PageController _controller = PageController(initialPage: 1);

  int _page = 1;
  int dateOffset = 0;
  DatabaseService databaseService = DatabaseService();

  void changeDate({required int amount}) {
    setState(() {
      dateOffset += amount;
      databaseService = DatabaseService(dateOffset: dateOffset);
    });
  }

  String formatDate() {
    DateTime date = DateTime.now().add(Duration(days: dateOffset));
    String formatted = DateFormat('EEEE, MMMM d').format(date);
    if (dateOffset == -1) formatted += ' (Yesterday)';
    if (dateOffset == 0) formatted += ' (Today)';
    if (dateOffset == 1) formatted += ' (Tomorrow)';
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return screenBase(
      context: context,
      title: 'My Day',
      subtitle: formatDate(), //'Make the most of it',
      settings: true,
      mainContent: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // events + to do + habits buttons
            SizedBox(
              width: MediaQuery.of(context).size.width * 4 / 5,
              height: 40,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _controller.animateToPage(0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.decelerate),
                      child: Text(
                        'Events',
                        style: headerStyle,
                        // style: TextStyle(
                        //   fontSize: 20,
                        // ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => _controller.animateToPage(1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.decelerate),
                      child: Text(
                        'To Do',
                        style: headerStyle,
                        // style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _controller.animateToPage(2,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.decelerate),
                      child: Text(
                        'Habits',
                        style: headerStyle,
                        // style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  AnimatedAlign(
                    alignment: (() {
                      switch (_page) {
                        case 0:
                          return const Alignment(-1, 1);
                        case 1:
                          return const Alignment(0, 1);
                        case 2:
                          return const Alignment(1, 1);
                        default:
                          return const Alignment(0, 1);
                      }
                    })(),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.decelerate,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        color: const Color(0xff40CDC5),
                        width: (() {
                          switch (_page) {
                            case 0:
                              return getTextSize(
                                'Events',
                                headerStyle,
                              ).width;
                            case 1:
                              return getTextSize(
                                'To Do',
                                headerStyle,
                              ).width;
                            case 2:
                              return getTextSize(
                                'Habits',
                                headerStyle,
                              ).width;
                          }
                        })(),
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (newPage) => setState(() => _page = newPage),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DailyEvents(databaseService),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DailyTodo(databaseService),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DailyHabits(databaseService),
                      ),
                    ],
                  ),
                  // scroll day buttons
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => changeDate(amount: -1),
                            icon: const Icon(Icons.arrow_back),
                            splashRadius: 24,
                          ),
                          IconButton(
                            onPressed: () => changeDate(amount: -dateOffset),
                            icon: const Icon(Icons.circle),
                            iconSize: 16,
                            splashRadius: 24,
                          ),
                          IconButton(
                            onPressed: () => changeDate(amount: 1),
                            icon: const Icon(Icons.arrow_forward),
                            splashRadius: 24,
                          ),
                        ],
                      ),
                    ),
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
