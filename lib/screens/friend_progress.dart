import 'package:flutter/material.dart';
import 'package:hackmhs2021/models/task.dart';
import 'package:hackmhs2021/models/user.dart';
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
    String friendEmail;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Tacked"),
        leading: IconButton(
            icon: Icon(Icons.notifications),
            tooltip: "bruh",
            onPressed: () {
              Navigator.pushNamed(context, '/notifs');
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add Friend'),
                  content: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //TODO: Grey out
                      Form(
                          key: _formKey,
                          child: TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a task' : null,
                              onChanged: (val) {
                                setState(() => friendEmail = val);
                              }))
                    ],
                  ),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () async {
                        database.addFriendRequest(requesteeEmail: friendEmail);
                        friendEmail = "";
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: database.user(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData user = snapshot.data;
                  return ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    visualDensity: VisualDensity(horizontal: 1, vertical: 1),
                    onTap: () => Navigator.pushNamed(context, '/personal'),
                    leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
                    title:
                        Text(user.firstName + " " + user.lastName + " (You)"),
                    // title: Text("please"),
                    subtitle: StreamBuilder(
                        stream: database.userTaskDataStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // print(snapshot.data);
                            List<Task> userTasks = snapshot.data;
                            double done = 0;
                            for (int i = 0; i < userTasks.length; i++) {
                              if (userTasks[i].done) done++;
                            }
                            // print(done / userTasks.length);

                            return LinearProgressIndicator(
                              minHeight: 7,
                              value: !(done == 0)
                                  ? (done / userTasks.length)
                                  : 0.0,
                              semanticsLabel: 'Linear progress indicator',
                            );
                          } else {
                            return Container();
                          }
                        }),
                  );
                } else
                  return ListTile();
              }),
          Divider(),
          Expanded(
            child: StreamBuilder(
                stream: database.userDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData user = snapshot.data;
                    List<String> friends = user.friends;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: database.user(friends[index]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  UserData friend = snapshot.data;
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                    child: ListTile(
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")),
                                        ],
                                      ),
                                      title: Text(friend.firstName +
                                          " " +
                                          friend.lastName),
                                      subtitle: Column(
                                            mainAxisAlignment:
                                              MainAxisAlignment.center,

                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height:5),
                                            StreamBuilder(
                                                stream:
                                                    database.userTaskDataStream(
                                                        userID: friend.uid),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    // print(snapshot.data);
                                                    List<Task> userTasks =
                                                        snapshot.data;
                                                    double done = 0;
                                                    for (int i = 0;
                                                        i < userTasks.length;
                                                        i++) {
                                                      if (userTasks[i].done)
                                                        done++;
                                                    }
                                                    // print(done / userTasks.length);

                                                    return LinearProgressIndicator(
                                                      minHeight: 7,
                                                      value: !(done == 0)
                                                          ? (done /
                                                              userTasks.length)
                                                          : 0.0,
                                                      semanticsLabel:
                                                          'Linear progress indicator',
                                                    );
                                                  } else {
                                                    // print("snapshot no data");
                                                    return Container();
                                                  }
                                                }),
                                            SizedBox(height: 5),
                                            FutureBuilder(
                                                future: database.getOneTask(
                                                    userID: friend.uid),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    Task task = snapshot.data;
                                                    return Text(
                                                        "Currently working on " +
                                                            task.description +
                                                            ".");
                                                  } else
                                                    return Text(
                                                        "No tasks to complete.");
                                                })
                                          ]),
                                    ),
                                  );
                                } else {
                                  print("error");
                                  return Container();
                                }
                              });
                        });
                  } else
                    return Container();
                }),
          ),
        ],
      ),
    );
  }
}
