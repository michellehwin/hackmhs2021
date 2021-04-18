import 'package:flutter/material.dart';
import 'package:hackmhs2021/models/user.dart';
import 'package:hackmhs2021/services/database.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Notifications"),
        ),
        body: StreamBuilder(
            stream: database.userDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> pendingFriends = snapshot.data.pendingFriends;
                // print(pendingFriends);
                return ListView.builder(
                    itemCount: pendingFriends.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: database.user(pendingFriends[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserData pendingUser = snapshot.data;
                              // print(pendingUser.firstName);
                              return ListTile(
                                  leading: Text(pendingUser.firstName +
                                      " " +
                                      pendingUser.lastName),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextButton(
                                            child: Text("Accept"),
                                            onPressed: () {
                                              database.acceptFriend(
                                                  friendID: pendingUser.uid);
                                            }),
                                        TextButton(
                                            child: Text("Ignore"),
                                            onPressed: () {
                                              // print("ignoring friends: " + pendingUser.uid);
                                              database.ignoreFriend(
                                                  friendID: pendingUser.uid);
                                            })
                                      ]));
                            } else
                              return Container();
                          });
                    });
              } else
                return Container();
            }));
  }
}
