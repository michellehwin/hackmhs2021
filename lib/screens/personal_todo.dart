import 'package:flutter/material.dart';
import 'package:hackmhs2021/models/task.dart';
import 'package:hackmhs2021/services/database.dart';
import 'package:provider/provider.dart';

class PersonalTodo extends StatefulWidget {
  @override
  _PersonalTodoState createState() => _PersonalTodoState();
}

class _PersonalTodoState extends State<PersonalTodo> {
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
      ),
      body: StreamBuilder(
          stream: database.userTaskDataStream,
          builder: (context, snapshot) {
            print(snapshot.data);
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
                title: const Text('Popup example'),
                content: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TODO: Grey out
                    Text("Hello"),
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
                      await database.addTask(description: description);
                      print(description);
                      Navigator.of(context).pop();
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
