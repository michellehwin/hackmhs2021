import 'package:hackmhs2021/screens/auth/register.dart';
import 'package:hackmhs2021/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void _pushRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Register()));
  }

  void _pushSignIn() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          Text(
            "Tacked",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              child: Text(
                "Create an account",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: _pushRegister),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
              child: Text(
                "Sign In"
              ),
              onPressed: _pushSignIn),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    ));
  }
}
