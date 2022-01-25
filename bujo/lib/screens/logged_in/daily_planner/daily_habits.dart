import 'package:bujo/services/database.dart';
import 'package:bujo/shared/constants.dart';
import 'package:flutter/material.dart';

class DailyHabits extends StatefulWidget {
  const DailyHabits(this.databaseService, {Key? key}) : super(key: key);

  final DatabaseService databaseService;

  @override
  _DailyHabitsState createState() => _DailyHabitsState();
}

class _DailyHabitsState extends State<DailyHabits> {
  HabitStates status = HabitStates.future;

  void cycleHabitStatus() => setState(() {
        switch (status) {
          case HabitStates.future:
            status = HabitStates.done;
            break;
          case HabitStates.done:
            status = HabitStates.failed;
            break;
          case HabitStates.failed:
            status = HabitStates.excused;
            break;
          case HabitStates.excused:
            status = HabitStates.future;
            break;
          case HabitStates.notToday:
            status = HabitStates.future;
            break;
        }
      });

  void toggleHabitToday() => setState(() => status == HabitStates.notToday
      ? status = HabitStates.future
      : status = HabitStates.notToday);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, i) {
        return HabitCard(
          habit: 'Cold Shower',
          status: status,
          cycleStatus: cycleHabitStatus,
          toggleHabitToday: toggleHabitToday,
        );
      },
      separatorBuilder: (context, i) => const SizedBox(height: 10),
    );
  }
}

class HabitCard extends StatelessWidget {
  const HabitCard({
    Key? key,
    required this.habit,
    required this.status,
    required this.cycleStatus,
    required this.toggleHabitToday,
  }) : super(key: key);

  final String habit;
  final HabitStates status;
  final Function cycleStatus;
  final Function toggleHabitToday;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => cycleStatus(),
      onLongPress: () => toggleHabitToday(),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: status == HabitStates.notToday
            ? const Color(0x30ffffff)
            : const Color(0x38ffffff),
        primary: status == HabitStates.notToday
            ? const Color(0x30ffffff)
            : Colors.white,
      ),
      child: AbsorbPointer(
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: () {
                        switch (status) {
                          case HabitStates.done:
                            return CheckboxColors.green
                                .withOpacity(CheckboxColors.innerOpacity);
                          case HabitStates.notToday:
                            return Colors.transparent;
                          case HabitStates.failed:
                            return CheckboxColors.red
                                .withOpacity(CheckboxColors.innerOpacity);
                          case HabitStates.excused:
                            return CheckboxColors.yellow
                                .withOpacity(CheckboxColors.innerOpacity);
                          default:
                            return CheckboxColors.white
                                .withOpacity(CheckboxColors.innerOpacity);
                        }
                      }(),
                      border: Border.all(
                        color: () {
                          switch (status) {
                            case HabitStates.done:
                              return CheckboxColors.green
                                  .withOpacity(CheckboxColors.outlineOpacity);
                            case HabitStates.notToday:
                              return Colors.transparent;
                            case HabitStates.failed:
                              return CheckboxColors.red
                                  .withOpacity(CheckboxColors.outlineOpacity);
                            case HabitStates.excused:
                              return CheckboxColors.yellow
                                  .withOpacity(CheckboxColors.outlineOpacity);
                            default:
                              return CheckboxColors.white
                                  .withOpacity(CheckboxColors.outlineOpacity);
                          }
                        }(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: status == HabitStates.done,
                    child: const Align(
                      alignment: Alignment(1, -0.5),
                      child: Icon(
                        Icons.check,
                        size: 25,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  habit,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
