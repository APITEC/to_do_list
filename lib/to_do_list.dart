import 'package:flutter/material.dart';

// Widgets
import 'task.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List toDoList = [
    {'name': 'Work out', 'status': true},
    {'name': 'Program', 'status': false},
    {'name': 'Have a drink', 'status': true}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'To Do',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                    ),
                  ),
                  Text(
                    'N items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    toDo: toDoList[index],
                    callback: (status) {
                      setState(() {
                        toDoList[index]['status'] = status;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Task'),
              content: TextField(),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Add!',
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ),
              ],
            ),
          );
        },
        label: Text('Add Task'),
      ),
    );
  }
}