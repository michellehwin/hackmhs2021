import 'package:hackmhs2021/models/user.dart';
import 'package:hackmhs2021/screens/auth/auth.dart';
import 'package:hackmhs2021/screens/home.dart';
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
        child: Home(),
      );
    }
  }
}
