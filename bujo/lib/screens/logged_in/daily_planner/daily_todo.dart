import 'package:bujo/screens/logged_in/daily_planner/todo_bottom_bar.dart';
import 'package:bujo/services/database.dart';
import 'package:bujo/shared/bottom_bar.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DailyTodo extends StatefulWidget {
  const DailyTodo({Key? key}) : super(key: key);

  @override
  _DailyTodoState createState() => _DailyTodoState();
}

class _DailyTodoState extends State<DailyTodo> {
  @override
  Widget build(BuildContext context) {
    void showEditPanel({required TodoInfo? todo}) {
      showBottomEditBar(context, TodoBottomBar(todo: todo));
    }

    return StreamProvider<List<TodoInfo>>.value(
      initialData: const [],
      value: DatabaseService().dailyTodos,
      builder: (context, child) {
        List<TodoInfo> todos = Provider.of<List<TodoInfo>>(context);
        return Scaffold(
          backgroundColor: const Color(0xff000C35),
          body: ListView.separated(
            itemCount: todos.length + 1,
            itemBuilder: (context, i) {
              return i < todos.length
                  ? TodoCard(
                      todo: todos[i],
                      showEditPanel: showEditPanel,
                    )
                  : const SizedBox(height: 45);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showEditPanel(todo: null),
            child: const Icon(
              Icons.add,
              size: 36,
            ),
          ),
        );
      },
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.todo,
    required this.showEditPanel,
  }) : super(key: key);

  final TodoInfo todo;
  final Function showEditPanel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      height: 45,
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              icon: Icons.forward,
              backgroundColor: Colors.green,
              onPressed: (context) {},
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (context) {},
            ),
          ],
        ),
        child: TextButton(
          onPressed: () async {
            DatabaseService().toggleTodoDone(todo);
          },
          onLongPress: () => showEditPanel(
            todo: TodoInfo(
              name: todo.name,
              done: todo.done,
              category: todo.category,
              order: 1,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor:
                todo.done ? const Color(0x30ffffff) : const Color(0x38ffffff),
            primary: todo.done ? const Color(0x30ffffff) : Colors.white,
            shape: const RoundedRectangleBorder(), // set border radius = 0
          ),
          child: AbsorbPointer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          color: todo.done
                              ? todoCategoryColors[todo.category]
                                  .withOpacity(CheckboxColors.innerOpacityDim)
                              : todoCategoryColors[todo.category]
                                  .withOpacity(CheckboxColors.innerOpacity),
                          border: Border.all(
                            color: todo.done
                                ? todoCategoryColors[todo.category].withOpacity(
                                    CheckboxColors.outlineOpacityDim)
                                : todoCategoryColors[todo.category]
                                    .withOpacity(CheckboxColors.outlineOpacity),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: todo.done,
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
                Text(
                  todo.name,
                  style: TextStyle(
                    fontSize: 16,
                    decoration: todo.done ? TextDecoration.lineThrough : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
