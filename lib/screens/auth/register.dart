import 'package:hackmhs2021/services/auth.dart';
import 'package:hackmhs2021/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: (IconThemeData(color: Colors.black)),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                child: Icon(Icons.arrow_forward),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result;
                    result = await _auth.registerWithEmailAndPw(
                      email,
                      password,
                      firstName,
                      lastName,
                    );
                    if (result != null) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  } else {
                    setState(() {
                      error = 'Please select a school';
                    });
                  }
                }),
            body: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Create an account",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          TextFormField(
                              decoration:
                                  InputDecoration(helperText: "First Name"),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              onChanged: (val) {
                                setState(() => firstName = val);
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                              decoration:
                                  InputDecoration(helperText: "Last Name"),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              onChanged: (val) {
                                setState(() => lastName = val);
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                              decoration: InputDecoration(helperText: "Email"),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                              decoration:
                                  InputDecoration(helperText: "Password"),
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              }),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                )));
  }
}
