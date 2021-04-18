import 'package:hackmhs2021/models/user.dart';
import 'package:hackmhs2021/screens/auth/auth.dart';
import 'package:hackmhs2021/screens/friend_progress.dart';
import 'package:hackmhs2021/screens/personal_todo.dart';
import 'package:hackmhs2021/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //returns either Feed or Auth widget
    if (user == null) {
      return Authenticate();
    } else {
      print("initialized");
      return MultiProvider(
        providers: [
          // Provider<FirestoreService>(
          //   create: (_) => FirestoreService(uid: user.uid),
          // ),
          Provider<DatabaseService>(
              create: (_) => DatabaseService(uid: user.uid))
        ],
        child: MaterialApp(
            title: 'Named Routes Demo',
            // Start the app with the "/" named route. In this case, the app starts
            // on the FirstScreen widget.
            initialRoute: '/',
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.
              '/': (context) => FriendProgress(),
              // When navigating to the "/second" route, build the SecondScreen widget.
              '/personal': (context) => PersonalTodo(),
            },
          )
      );
    }
  }
}
