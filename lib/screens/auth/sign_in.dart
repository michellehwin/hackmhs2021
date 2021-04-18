import 'package:hackmhs2021/services/auth.dart';
import 'package:hackmhs2021/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: (IconThemeData(color: Colors.black)),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Sign In",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(helperText: "Email"),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                          decoration: InputDecoration(helperText: "Password"),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      SizedBox(height: 20),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          color: Colors.green,
                          child: Text('Sign in',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithEmailAndPw(
                                  email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      "Could not sign in with those credentials";
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          }),
                      SizedBox(height: 12),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14))
                    ],
                  ),
                )));
  }
}
