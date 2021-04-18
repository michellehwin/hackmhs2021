import 'package:flutter/material.dart';
import 'package:hackmhs2021/screens/personal_todo.dart';
import 'package:hackmhs2021/services/auth.dart';
import 'package:hackmhs2021/services/database.dart';
import 'package:provider/provider.dart';

class FriendProgress extends StatefulWidget {
  @override
  _FriendProgressState createState() => _FriendProgressState();
}

class _FriendProgressState extends State<FriendProgress> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: new AppBar(title: new Text("Tacked")),
      body: Column(
        children: [
          Text("Test"),
          ElevatedButton(
              onPressed: () {
                database.addTask(description: "fix flutter");
              },
              child: Text("Please DB")),
          ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text("Sign Out")),
          ElevatedButton(
              onPressed: () {
                print("why won't you nav");
                Navigator.pushNamed(context, '/personal');
              },
              child: Text("Personal Todo"))
        ],
      ),
    );
  }
}
