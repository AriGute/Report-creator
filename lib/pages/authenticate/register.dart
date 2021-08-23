import 'package:flutter/material.dart';
import 'package:CreateReport/pages/shared/loading.dart';
import 'package:CreateReport/services/auth.dart';
import 'package:CreateReport/pages/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Colors.white;

    return isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.red[500],
              elevation: 0.0,
              title: Text('Sign up:'),
              actions: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(
                    Icons.person,
                    color: appBarColor,
                  ),
                  label: Text(
                    'Sign in',
                    style: TextStyle(color: appBarColor),
                  ),
                ),
              ],
            ),
            body: ListView(children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: boxSize,
                      ),
                      TextFormField(
                        decoration:
                            textIputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      SizedBox(
                        height: boxSize,
                      ),
                      TextFormField(
                        decoration:
                            textIputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.length <= 5
                            ? 'Enter password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      SizedBox(
                        height: boxSize,
                      ),
                      TextFormField(
                        decoration:
                            textIputDecoration.copyWith(hintText: 'First Name'),
                        validator: (val) =>
                            val.length < 0 ? 'Enter name' : null,
                        onChanged: (val) {
                          firstName = val;
                        },
                      ),
                      SizedBox(
                        height: boxSize,
                      ),
                      TextFormField(
                        decoration:
                            textIputDecoration.copyWith(hintText: 'Last Name'),
                        validator: (val) =>
                            val.length < 0 ? 'Enter name' : null,
                        onChanged: (val) {
                          lastName = val;
                        },
                      ),
                      SizedBox(
                        height: boxSize,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red[500]),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, firstName, lastName);
                              if (result == null) {
                                setState(() {
                                  isLoading = false;
                                  error = 'Invalid info or email alredy exist';
                                });
                              }
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(height: boxSize),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          );
  }
}
