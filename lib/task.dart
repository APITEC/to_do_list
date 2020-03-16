import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        showDialog(
          context: context,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
        await Firestore.instance.collection('tasks').document(toDo['document']).delete();
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hey!'),
            content: Text('${toDo['name']} removed from your list!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok!',
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              ),
            ],
          ),
        );
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
