class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String uid;
  String email;
  String firstName;
  String lastName;
  String pfpURL;

  UserData({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.pfpURL,
  });
}
