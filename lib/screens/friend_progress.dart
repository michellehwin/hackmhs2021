import 'package:flutter/material.dart';
import 'package:hackmhs2021/services/auth.dart';

class FriendProgress extends StatefulWidget {
  @override
  _FriendProgressState createState() => _FriendProgressState();
}

class _FriendProgressState extends State<FriendProgress> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Test"),
          ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text("Sign Out"))
        ],
      ),
    );
  }
}
