import 'package:flutter/material.dart';
import 'package:B.E.E/pages/models/create_pdf.dart';
import 'package:B.E.E/pages/models/report.dart';
import 'package:B.E.E/services/database.dart';

class ReportTile extends StatelessWidget {
  final Report report;
  ReportTile({this.report});

  @override
  Widget build(BuildContext context) {
    void _removeButton() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title:
                    Text("Delete report: " + report.name + " " + report.date),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      DatabaseService()
                          .deletReport(report.ownerUid, report.reportUid);
                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                    style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                      style: ElevatedButton.styleFrom(primary: Colors.red[500]))
                ],
              ),
          barrierDismissible: false);
    }

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
          trailing: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: Colors.grey[500],
            onPressed: _removeButton,
            tooltip: 'Increment',
            child: Icon(
              Icons.delete_forever,
              color: Colors.red[500],
            ),
          ),
          title: Text(report.date),
          subtitle: Text(report.name),
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => CreatePdf(report.ownerUid, report.reportUid));
          },
        ),
        color: Colors.grey[400],
      ),
    );
  }
}
