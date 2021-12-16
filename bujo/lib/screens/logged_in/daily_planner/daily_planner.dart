import 'package:bujo/screens/logged_in/daily_planner/daily_events.dart';
import 'package:bujo/screens/logged_in/daily_planner/daily_habits.dart';
import 'package:bujo/screens/logged_in/daily_planner/daily_todo.dart';
import 'package:flutter/material.dart';

import 'package:bujo/shared/get_text_size.dart';
import 'package:bujo/shared/screen_base.dart';

class DailyPlanner extends StatefulWidget {
  const DailyPlanner({Key? key}) : super(key: key);

  @override
  _DailyPlannerState createState() => _DailyPlannerState();
}

class _DailyPlannerState extends State<DailyPlanner> {
  final PageController _controller = PageController(initialPage: 1);

  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return screenBase(
      title: 'My Day',
      subtitle: 'Make the most of it',
      settings: true,
      mainContent: Column(
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
                    child: const Text(
                      'Events',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => _controller.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.decelerate),
                    child: const Text(
                      'To Do',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _controller.animateToPage(2,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.decelerate),
                    child: const Text(
                      'Habits',
                      style: TextStyle(fontSize: 20),
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
                              const TextStyle(fontSize: 20),
                            ).width;
                          case 1:
                            return getTextSize(
                              'To Do',
                              const TextStyle(fontSize: 20),
                            ).width;
                          case 2:
                            return getTextSize(
                              'Habits',
                              const TextStyle(fontSize: 20),
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
            child: PageView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (newPage) => setState(() => _page = newPage),
              children: const [
                DailyEvents(),
                DailyTodo(),
                DailyHabits(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
