import 'package:hackmhs2021/models/task.dart';
import 'package:hackmhs2021/models/user.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  //set email and name
  Future updateUserData({
    String email,
    String firstName,
    String lastName,
  }) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  Future addTask({String description}) async {
    return await taskCollection
        .doc()
        .set({'description': description, 'uid': uid, 'done': false});
  }

  Future<UserData> user([String userID = ""]) async {
    // print("userID: " + userID);
    if (userID == "") {
      return await userCollection.doc(uid).get().then(_userFromSnapshot);
    } else {
      return await userCollection.doc(userID).get().then(_userFromSnapshot);
    }
  }

  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.id,
        email: snapshot.data()['email'],
        firstName: snapshot.data()['firstName'],
        lastName: snapshot.data()['lastName'],
        pendingFriends: List.from(snapshot.data()['pendingFriends'] ?? []),
        friends: List.from(snapshot.data()['friends'] ?? []));
  }

  Stream<List<Task>> userTaskDataStream({userID = ""}) {
    if(userID == "")
    return taskCollection
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map(_taskListFromStream);
        else return taskCollection
          .where("uid", isEqualTo: userID)
          .snapshots()
          .map(_taskListFromStream);
  }

  Future<List<Task>> get userTasks async {
    QuerySnapshot qs = await taskCollection.where("uid", isEqualTo: uid).get();
    return qs.docs.map(_taskListFromSnapshot).toList();
  }

  Task _taskListFromSnapshot(DocumentSnapshot snapshot) {
    return Task(
        id: snapshot.id,
        done: snapshot.data()['done'],
        description: snapshot.data()['description']);
  }

  List<Task> _taskListFromStream(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task(
        description: doc.data()['description'],
        done: doc.data()['done'],
        id: doc.id,
      );
    }).toList();
  }

  void setTask({String taskID, bool done}) {
    taskCollection.doc(taskID).set({'done': done}, SetOptions(merge: true));
  }

  void addFriendRequest({String requesteeEmail}) {
    userCollection
        .where("email", isEqualTo: requesteeEmail)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      userCollection.doc(snapshot.docs[0].id).set({
        'pendingFriends': FieldValue.arrayUnion([uid])
      }, SetOptions(merge: true));
    });
  }

  //get userData stream
  Stream<UserData> get userDataStream {
    return userCollection.doc(uid).snapshots().map(_userDataFromStream);
  }

  //userData from Stream
  UserData _userDataFromStream(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.id,
        email: snapshot.data()['email'],
        firstName: snapshot.data()['firstName'],
        lastName: snapshot.data()['lastName'],
        pendingFriends: List.from(snapshot.data()['pendingFriends'] ?? []),
        friends: List.from(snapshot.data()['friends'] ?? []));
  }

  void acceptFriend({String friendID}) {
    userCollection.doc(uid).set({
      "friends": FieldValue.arrayUnion([
        friendID,
      ]),
      "pendingFriends": FieldValue.arrayRemove([friendID])
    }, SetOptions(merge: true));
    userCollection.doc(friendID).set({
      "friends": FieldValue.arrayUnion([
        uid,
      ])
    }, SetOptions(merge: true));
  }

  void ignoreFriend({String friendID}) {
    // print(uid + " friendID: " + friendID);
    userCollection.doc(uid).update({
      "pendingFriends": FieldValue.arrayRemove([friendID])
    });
  }
}
