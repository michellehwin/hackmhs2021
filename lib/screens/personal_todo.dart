import 'package:flutter/material.dart';
import 'package:hackmhs2021/models/task.dart';

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
          onPressed: _addTodoItem,
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }
}
