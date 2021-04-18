import 'package:flutter/material.dart';
import 'package:hackmhs2021/models/task.dart';
import 'package:hackmhs2021/services/auth.dart';
import 'package:hackmhs2021/services/database.dart';
import 'package:provider/provider.dart';

class PersonalTodo extends StatefulWidget {
  @override
  _PersonalTodoState createState() => _PersonalTodoState();
}

class _PersonalTodoState extends State<PersonalTodo> {
  final AuthService _auth = AuthService();

  List<Task> _todoItems = [];

  void _addTodoItem() {
    setState(() {
      int index = _todoItems.length;
      _todoItems.add(new Task(
          id: index.toString(),
          description: "Task " + index.toString(),
          done: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    String description;
    final _formKey = GlobalKey<FormState>();

    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Todo List'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.sensor_door),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //TODO: Grey out
                          Text("Are you sure you want to sign out?")
                        ],
                      ),
                      actions: <Widget>[
                        new TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _auth.signOut();
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                })
          ]),
      body: StreamBuilder(
          stream: database.userTaskDataStream(),
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (!snapshot.hasData)
              return ListTile(title: Text("Loading..."));
            else {
              List<Task> tasks = snapshot.data;
              return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        value: tasks[index].done,
                        title: !tasks[index].done
                            ? Text(tasks[index].description)
                            : Text(tasks[index].description,
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                )),
                        onChanged: (bool val) {
                          database.setTask(taskID: tasks[index].id, done: val);
                        });
                  });
            }
          }),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Add Task'),
                content: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TODO: Grey out
                    Text("Enter your task."),
                    Form(
                        key: _formKey,
                        child: TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter a task' : null,
                            onChanged: (val) {
                              setState(() => description = val);
                            }))
                  ],
                ),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await database.addTask(description: description);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }
}
