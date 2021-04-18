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
                return ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(thickness: 1, height: 1),
                    itemCount: pendingFriends.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: database.user(pendingFriends[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserData pendingUser = snapshot.data;
                              // print(pendingUser.firstName);
                              return ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  title: Text(pendingUser.firstName +
                                      " " +
                                      pendingUser.lastName +
                                      " wants to be your friend!"),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextButton(
                                            child: Text("Accept",
                                                style: TextStyle(
                                                    color: Colors.green)),
                                            onPressed: () {
                                              database.acceptFriend(
                                                  friendID: pendingUser.uid);
                                            }),
                                        TextButton(
                                            child: Text("Ignore",
                                                style: TextStyle(
                                                    color: Colors.red)),
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
