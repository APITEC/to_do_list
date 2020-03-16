import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widgets
import 'task.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  String newTaskName;
  String newDueDate = '';
  List toDoList = [];
  bool loaded = false;

  int getIncompleteTasks() {
    int incompleteTasks = 0;

    toDoList.forEach((task) {
      if (!task['status']) {
        incompleteTasks++;
      }
    });
    return incompleteTasks;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Firestore.instance.collection('tasks').getDocuments().then(
          (data) => data.documents.forEach(
            (doc) => toDoList.add(
              {
                'document': doc.documentID,
                'name': doc['name'],
                'status': doc['status'] == 'true',
                'dueDate': doc['dueDate'],
              },
            ),
          ),
        );
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    '${toDoList.where((task) => !task['status']).length} items',
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
              child: loaded
                  ? ListView.builder(
                      itemCount: toDoList.length,
                      itemBuilder: (context, index) {
                        return TaskTile(
                          toDo: toDoList[index],
                          changeTaskStatus: (status) {
                            setState(
                              () {
                                toDoList[index]['status'] = status;
                              },
                            );
                          },
                          deleteTask: () {
                            setState(() {
                              toDoList.removeAt(index);
                            });
                          },
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      newTaskName = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      print('Hola pablo.');
                    },
                    onTap: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      print(selectedDate);
                      newDueDate = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                    },
                    child: Text(
                      'Add due date',
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    String documentId;
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    await Firestore.instance.collection('tasks').add({'name': newTaskName, 'status': false, 'dueDate': newDueDate}).then((document) => documentId = document.documentID);
                    Navigator.pop(context);
                    newDueDate = '';
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Hey!'),
                        content: Text('$newTaskName added to your list!'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Add!',
                              style: TextStyle(color: Colors.pinkAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                    setState(() {
                      toDoList.add({'document': documentId, 'name': newTaskName, 'status': false, 'dueDate': newDueDate});
                    });
                  },
                  child: Text(
                    'Ok!',
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
