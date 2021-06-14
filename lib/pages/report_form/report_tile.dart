import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/report.dart';
import 'package:save_pdf/pages/report_form/report_display.dart';

class ReportTile extends StatelessWidget {
  final Report report;
  ReportTile({this.report});

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
          title: Text(report.date),
          subtitle: Text(report.name),
          onTap: () {
            // TODO: download report as pdf / open report
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReportDisplay(report.ownerUid, report.reportUid)),
            );
          },
        ),
        color: Colors.grey[400],
      ),
    );
  }
}
