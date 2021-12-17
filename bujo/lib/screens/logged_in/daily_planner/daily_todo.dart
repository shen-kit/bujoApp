import 'package:bujo/shared/constants.dart';
import 'package:flutter/material.dart';

class DailyTodo extends StatefulWidget {
  const DailyTodo({Key? key}) : super(key: key);

  @override
  _DailyTodoState createState() => _DailyTodoState();
}

class _DailyTodoState extends State<DailyTodo> {
  bool _done = false;

  void toggleDone() => setState(() => _done = !_done);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000C35),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, i) {
          return TodoCard(
            todo: 'Find Spec OT Lee Textbook',
            done: _done,
            toggleDone: toggleDone,
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
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

class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.todo,
    required this.done,
    required this.toggleDone,
  }) : super(key: key);

  final String todo;
  final bool done;
  final Function toggleDone;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => toggleDone(),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor:
            done ? const Color(0x30ffffff) : const Color(0x38ffffff),
        primary: done ? const Color(0x30ffffff) : Colors.white,
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
                      color: done
                          ? CheckboxColors.blueInsideDim
                          : CheckboxColors.blueInside,
                      border: Border.all(
                        color: done
                            ? CheckboxColors.blueOutlineDim
                            : CheckboxColors.blueOutline,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: done,
                    child: const Align(
                      alignment: Alignment(1, -0.5),
                      child: Icon(
                        Icons.check,
                        size: 25,
                        color: Color(0x8affffff),
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
                  todo,
                  style: TextStyle(
                    fontSize: 16,
                    decoration: done ? TextDecoration.lineThrough : null,
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
