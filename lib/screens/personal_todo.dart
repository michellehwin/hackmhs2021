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

  void _onToggle(Task task) {
    setState(() {
      task.done = (!task.done);
    });
  }

  Widget _buildPopupDialog(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    String description;
    final _formKey = GlobalKey<FormState>();

    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
          Form(
              key: _formKey,
              child: TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter a task' : null,
                  onChanged: (val) {
                    setState(() => description = val);
                  }))
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            database.addTask(description:description);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ListView.builder(
          itemCount: _todoItems.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
                title: Text(_todoItems[index].description),
                value: _todoItems[index].done,
                onChanged: (_) => _onToggle(_todoItems[index]));
          }),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _buildPopupDialog(context),
            );
          },
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }
}
