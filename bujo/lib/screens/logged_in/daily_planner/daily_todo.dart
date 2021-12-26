import 'package:bujo/shared/bottom_bar.dart';
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
    void showEditPanel({String? name}) {
      TextEditingController todoNameController =
          TextEditingController(text: name ?? '');

      showBottomEditBar(
        context,
        Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name == null ? 'New To-Do' : 'Edit To-Do',
                style: headerStyle,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: todoNameController,
                validator: (val) =>
                    val!.isEmpty ? 'To-Do can\'t be empty' : null,
                decoration: textInputDecoration.copyWith(labelText: 'To-Do'),
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
      backgroundColor: const Color(0xff000C35),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, i) {
          return TodoCard(
            todo: 'Do Stuff',
            done: _done,
            toggleDone: toggleDone,
            showEditPanel: showEditPanel,
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showEditPanel,
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
    required this.showEditPanel,
  }) : super(key: key);

  final String todo;
  final bool done;
  final Function toggleDone;
  final Function showEditPanel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => toggleDone(),
      onLongPress: () => showEditPanel(name: todo),
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
