import 'package:cloud_firestore/cloud_firestore.dart';
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
      onLongPress: () async {
        bool confirm = false;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hey!'),
            content: Text('You are about to delete ${toDo['name']}. This action cannot be undone. Proceed?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                  ),
                ),
                onPressed: () {
                  confirm = true;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
        if (confirm) {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
          await Firestore.instance.collection('tasks').document(toDo['document']).delete();
          Navigator.pop(context);
          deleteTask();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hey!'),
              content: Text('You deleted the task ${toDo['name']}.'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
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
        onChanged: (value) async {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
          await Firestore.instance.collection('tasks').document(toDo['document']).updateData({'status': value});
          Navigator.pop(context);
          changeTaskStatus(value);
        },
      ),
    );
  }
}
