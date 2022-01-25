import 'package:bujo/services/database.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/todo.dart';
import 'package:flutter/material.dart';

class TodoBottomBar extends StatefulWidget {
  const TodoBottomBar(this.databaseService,
      {this.todo, this.todoCount, Key? key})
      : super(key: key);

  @override
  _TodoBottomBarState createState() => _TodoBottomBarState();

  final TodoInfo? todo;
  final int? todoCount;
  final DatabaseService databaseService;
}

class _TodoBottomBarState extends State<TodoBottomBar> {
  final _formKey = GlobalKey<FormState>();

  TodoInfo? todo;
  final TextEditingController todoNameController =
      TextEditingController(text: '');
  int _category = 0;

  // prevent error from tapping 'save' twice
  bool _exiting = false;

  @override
  void initState() {
    super.initState();

    todo = widget.todo;
    if (todo != null) {
      todoNameController.text = todo!.name;
      _category = todo!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.todo == null ? 'New To-Do' : 'Edit To-Do',
            style: headerStyle,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: todoNameController,
            validator: (val) => val!.isEmpty ? 'To-Do can\'t be empty' : null,
            decoration: textInputDecoration.copyWith(labelText: 'To-Do'),
            style: textInputStyle,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Radio<int>(
                value: 0,
                groupValue: _category,
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                fillColor: MaterialStateProperty.all(CheckboxColors.white),
              ),
              Radio<int>(
                value: 1,
                groupValue: _category,
                onChanged: (value) => setState(() {
                  _category = value!;
                }),
                fillColor: MaterialStateProperty.all(CheckboxColors.red),
              ),
              Radio<int>(
                value: 2,
                groupValue: _category,
                onChanged: (value) => setState(() {
                  _category = value!;
                }),
                fillColor: MaterialStateProperty.all(CheckboxColors.yellow),
              ),
              Radio<int>(
                value: 3,
                groupValue: _category,
                onChanged: (value) => setState(() {
                  _category = value!;
                }),
                fillColor: MaterialStateProperty.all(CheckboxColors.blue),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate() || _exiting) return;

                _exiting = true;

                TodoInfo newTodoInfo = TodoInfo(
                  docId: todo?.docId,
                  name: todoNameController.text,
                  done: todo == null ? false : todo!.done,
                  category: _category,
                  order: todo == null ? widget.todoCount! : todo!.order,
                );

                // new event
                if (todo == null) {
                  await widget.databaseService.addTodo(newTodoInfo);
                } else {
                  await widget.databaseService.updateTodo(newTodoInfo);
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
