import 'package:flutter/material.dart';

import 'package:bujo/screens/logged_in/habits.dart';
import 'package:bujo/screens/logged_in/calendar.dart';
import 'package:bujo/screens/logged_in/daily_planner/daily_planner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  final PageController _controller = PageController(initialPage: 1);

  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (value) => setState(() => pageIndex = value),
        children: const [
          Calendar(),
          DailyPlanner(),
          Habits(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        backgroundColor: const Color(0x14ffffff),
        onTap: (index) => _controller.animateToPage(index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate),
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.calendar,
              size: 22,
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'My Day',
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.check_box_outlined),
            icon: FaIcon(FontAwesomeIcons.checkSquare),
            label: 'Habits',
          ),
        ],
      ),
    );
  }
}
