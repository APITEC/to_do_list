import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key key,
    @required this.toDo,
    @required this.changeTaskStatus,
    @required this.deleteTask,
  }) : super(key: key);

  final Map toDo;
  final Function changeTaskStatus;
  final Function deleteTask;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        deleteTask();
      },
      child: CheckboxListTile(
        title: Text(
          toDo['name'],
          style: TextStyle(
            decoration: toDo['status'] ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(toDo['dueDate'] != '' ? 'due on ${toDo['dueDate']}' : ''),
        checkColor: Colors.white,
        activeColor: Colors.pinkAccent,
        value: toDo['status'],
        onChanged: (value) {
          changeTaskStatus(value);
        },
      ),
    );
  }
}
