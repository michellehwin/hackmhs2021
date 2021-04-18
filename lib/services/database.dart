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
        .doc(uid)
        .set({'description': description, 'uid': uid, 'done': false});
  }
}
