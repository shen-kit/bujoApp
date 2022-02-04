import 'package:bujo/services/database.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/habit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyHabits extends StatefulWidget {
  const DailyHabits(this.databaseService, {Key? key}) : super(key: key);

  final DatabaseService databaseService;

  @override
  _DailyHabitsState createState() => _DailyHabitsState();
}

class _DailyHabitsState extends State<DailyHabits> {
  cycleHabitStatus(String docId, String status) {
    switch (status) {
      case 'future':
        widget.databaseService.setHabitCompletionStatus(docId, 'partial');
        widget.databaseService
            .onHabitStatusChanged(docId, '', 'partially_completed');
        break;
      case 'partial':
        widget.databaseService.setHabitCompletionStatus(docId, 'done');
        widget.databaseService
            .onHabitStatusChanged(docId, 'partially_completed', 'completed');
        break;
      case 'done':
        widget.databaseService.setHabitCompletionStatus(docId, 'failed');
        widget.databaseService
            .onHabitStatusChanged(docId, 'completed', 'failed');
        break;
      case 'failed':
        widget.databaseService.setHabitCompletionStatus(docId, 'excused');
        widget.databaseService.onHabitStatusChanged(docId, 'failed', 'excused');
        break;
      case 'excused':
        widget.databaseService.setHabitCompletionStatus(docId, 'future');
        widget.databaseService.onHabitStatusChanged(docId, 'excused', '');
        break;
      case 'notToday':
        widget.databaseService.setHabitCompletionStatus(docId, 'future');
        break;
      default:
        return 'error';
    }
  }

  void toggleHabitToday(String docId, String status) {
    switch (status) {
      case 'partial':
        widget.databaseService
            .onHabitStatusChanged(docId, 'partially_completed', '');
        break;
      case 'done':
        widget.databaseService.onHabitStatusChanged(docId, 'completed', '');
        break;
      case 'failed':
        widget.databaseService.onHabitStatusChanged(docId, 'failed', '');
        break;
      case 'excused':
        widget.databaseService.onHabitStatusChanged(docId, 'excused', '');
        break;
    }
    status == 'notToday' ? status = 'future' : status = 'notToday';
    widget.databaseService.setHabitCompletionStatus(docId, status);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HabitCompletionInfo>>.value(
      initialData: const [],
      value: widget.databaseService.habitCompletion,
      builder: (context, child) {
        List<HabitCompletionInfo> habitCompletion =
            Provider.of<List<HabitCompletionInfo>>(context);
        return ListView.separated(
          itemCount: habitCompletion.length,
          itemBuilder: (context, i) {
            return HabitCard(
              docId: habitCompletion[i].docId!,
              habit: habitCompletion[i].name,
              status: habitCompletion[i].status,
              cycleStatus: cycleHabitStatus,
              toggleHabitToday: toggleHabitToday,
            );
          },
          separatorBuilder: (context, i) => const SizedBox(height: 10),
        );
      },
    );
  }
}

class HabitCard extends StatelessWidget {
  const HabitCard({
    Key? key,
    required this.docId,
    required this.habit,
    required this.status,
    required this.cycleStatus,
    required this.toggleHabitToday,
  }) : super(key: key);

  final String docId;
  final String habit;
  final String status;
  final Function cycleStatus;
  final Function toggleHabitToday;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => cycleStatus(docId, status),
      onLongPress: () => toggleHabitToday(docId, status),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: status == 'notToday'
            ? const Color(0x30ffffff)
            : const Color(0x38ffffff),
        primary: status == 'notToday' ? const Color(0x30ffffff) : Colors.white,
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
                          case 'notToday':
                            return Colors.transparent;
                          case 'done':
                            return CheckboxColors.green
                                .withOpacity(CheckboxColors.innerOpacity);
                          case 'partial':
                            return CheckboxColors.blue
                                .withOpacity(CheckboxColors.innerOpacity);
                          case 'failed':
                            return CheckboxColors.red
                                .withOpacity(CheckboxColors.innerOpacity);
                          case 'excused':
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
                            case 'notToday':
                              return Colors.transparent;
                            case 'done':
                              return CheckboxColors.green
                                  .withOpacity(CheckboxColors.outlineOpacity);
                            case 'partial':
                              return CheckboxColors.blue
                                  .withOpacity(CheckboxColors.outlineOpacity);
                            case 'failed':
                              return CheckboxColors.red
                                  .withOpacity(CheckboxColors.outlineOpacity);
                            case 'excused':
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
                    visible: status == 'done',
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
