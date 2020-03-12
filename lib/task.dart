import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key key,
    @required this.toDo,
    @required this.callback,
  }) : super(key: key);

  final Map toDo;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        toDo['name'],
        style: TextStyle(
          decoration: toDo['status'] ? TextDecoration.lineThrough : null,
        ),
      ),
      checkColor: Colors.white,
      activeColor: Colors.pinkAccent,
      value: toDo['status'],
      onChanged: (value) {
        callback(value);
      },
    );
  }
}
