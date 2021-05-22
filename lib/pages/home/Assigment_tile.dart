import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/assigment.dart';
import 'package:save_pdf/pages/models/report.dart';

class AssigmentTile extends StatelessWidget {
  final Assigment assigment;
  AssigmentTile({this.assigment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10.0, 0.6, 10.0, 0),
        child: ListTile(
          leading: Icon(
            Icons.assignment,
            color: Colors.red[500],
            size: 40.0,
          ),
          title: Text(assigment.subject),
          subtitle: Text(assigment.date),
          onTap: () {},
        ),
        color: Colors.grey[400],
      ),
    );
  }
}
