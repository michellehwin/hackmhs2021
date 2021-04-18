class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String uid;
  String email;
  String firstName;
  String lastName;
  List<String> pendingFriends;
  List<String> friends;

  UserData(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.pendingFriends, this.friends});
}
