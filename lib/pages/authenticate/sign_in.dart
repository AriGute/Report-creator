import 'package:flutter/material.dart';
import 'package:CreateReport/pages/shared/constants.dart';
import 'package:CreateReport/pages/shared/loading.dart';
import 'package:CreateReport/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Color appBarColor = Colors.white;
  bool isLoading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.red[500],
              elevation: 0.0,
              title: Text('Sign in:'),
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
                      'Register',
                    ))
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
                        keyboardType: TextInputType.emailAddress,
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
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red[500]),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  isLoading = false;
                                  error =
                                      'Could not sign in with those credntials';
                                });
                              }
                            }
                          },
                          child: Text(
                            'Sign in',
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
    ;
  }
}
