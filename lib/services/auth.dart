import 'package:hackmhs2021/models/user.dart';
import 'package:hackmhs2021/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in email and pw
  Future signInWithEmailAndPw(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      auth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register w email and pw
  Future registerWithEmailAndPw(String email, String password, String firstName,
      String lastName, bool isTeacher, String schoolID) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      auth.User user = result.user;
      //create a new document for the user with the uid
      DatabaseService service = DatabaseService(uid: user.uid);
      await service.updateUserData(
          email: email.trim(),
          firstName: firstName.trim(),
          lastName: lastName.trim());
      // print("database updated with email and username");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
