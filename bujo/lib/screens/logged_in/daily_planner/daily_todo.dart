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
    void showEditPanel({TodoInfo? todo, int? todoCount}) {
      showBottomEditBar(
        context,
        TodoBottomBar(
          todo: todo,
          todoCount: todoCount,
        ),
      );
    }

    return StreamProvider<List<TodoInfo>>.value(
      initialData: const [],
      value: DatabaseService().dailyTodos,
      builder: (context, child) {
        List<TodoInfo> todos = Provider.of<List<TodoInfo>>(context);
        return Scaffold(
          backgroundColor: const Color(0xff000C35),
          body: ReorderableListView.builder(
            proxyDecorator: (child, i, time) {
              return Container(
                child: child,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(8, 0),
                    ),
                  ],
                ),
              );
            },
            itemCount: todos.length + 1,
            itemBuilder: (context, i) {
              return i < todos.length
                  ? TodoCard(
                      key: Key(todos[i].docId!),
                      todo: todos[i],
                      showEditPanel: showEditPanel,
                    )
                  : SizedBox(key: UniqueKey(), height: 45);
            },
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex--;
              }
              // order starts at 1, index = order
              TodoInfo temp = todos.removeAt(oldIndex);
              todos.insert(newIndex, temp);
              List<String> docIds = todos.map((todo) => todo.docId!).toList();
              DatabaseService().reorderTodos(docIds);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showEditPanel(todoCount: todos.length),
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
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        key: Key(todo.docId!),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              icon: Icons.arrow_back_ios,
              backgroundColor: Colors.purple,
              onPressed: (context) {
                DatabaseService().migrateToDo(todo, false);
              },
            ),
            SlidableAction(
              icon: Icons.arrow_forward_ios,
              backgroundColor: Colors.green,
              onPressed: (context) {
                DatabaseService().migrateToDo(todo, true);
              },
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
              onPressed: (context) => DatabaseService().deleteTodo(todo.docId),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () async {
            DatabaseService().toggleTodoDone(todo);
          },
          onLongPress: () => showEditPanel(todo: todo),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor:
                todo.done ? const Color(0x30ffffff) : const Color(0x38ffffff),
            primary: todo.done ? const Color(0x30ffffff) : Colors.white,
            shape: const RoundedRectangleBorder(), // remove border radius
          ),
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
                              ? todoCategoryColors[todo.category]
                                  .withOpacity(CheckboxColors.outlineOpacityDim)
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
              const Expanded(child: SizedBox()),
              ReorderableDragStartListener(
                  child: const Icon(Icons.drag_handle), index: todo.order),
            ],
          ),
        ),
      ),
    );
  }
}
