import 'package:flutter/material.dart';
import 'package:save_pdf/services/auth.dart';

Widget profileSettings(AuthService _auth, BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
      child: Column(
        children: [
          FlatButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text("Log out")),
        ],
      ));
}
