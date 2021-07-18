import 'package:flutter/material.dart';
import 'package:B.E.E/pages/models/assignment.dart';
import 'package:B.E.E/pages/report_form/report_form_page.dart';

class AssigmentTile extends StatelessWidget {
  final Assignment assigment;
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
          onTap: () {
            print(assigment.uid);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReportForm(
                          assigment: assigment,
                        )));
          },
        ),
        color: Colors.grey[400],
      ),
    );
  }
}
