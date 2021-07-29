import 'package:flutter/material.dart';
import 'package:B.E.E/services/auth.dart';

Widget profileSettings(AuthService _auth, BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
      child: Column(
        children: [
          Container(
              child: Text(
            "Settings:",
            style: TextStyle(fontSize: 20),
          )),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.red[500]),
              onPressed: () async {
                Navigator.pop(context);
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text("Log out"))
        ],
      ));
}
