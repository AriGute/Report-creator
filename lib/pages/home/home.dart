import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home/docs_list.dart';
import 'package:save_pdf/services/auth.dart';
import 'package:save_pdf/services/auth.dart';
import 'package:save_pdf/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Color appBarTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().docs(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          title: Text(
            'Report',
            style: TextStyle(color: appBarTextColor),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.person,
                color: appBarTextColor,
              ),
              label: Text(
                'Log out',
                style: TextStyle(color: appBarTextColor),
              ),
            ),
          ],
        ),
        // body: DocsList(),
        // body: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.add_box),
        // ),
      ),
    );
  }
}
