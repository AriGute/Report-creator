import 'package:B.E.E/pages/models/create_pdf.dart';
import 'package:flutter/material.dart';
import 'package:B.E.E/pages/report_form/report_view/photo_viewer.dart';
import 'package:B.E.E/pages/waiting%20to%20be%20deleted/create_pdf2.dart';
import 'package:B.E.E/pages/models/report.dart';
import 'package:B.E.E/services/database.dart';

class ReportTile extends StatelessWidget {
  final Report report;
  final DatabaseService db = DatabaseService();
  ReportTile({this.report});

  Future<List<String>> getPhotosUrls() async {
    return await DatabaseService().getPhotos(report.reportUid);
  }

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
                      db.deletReport(report.ownerUid, report.reportUid);
                      db.deletePhotos(report.reportUid);
                      Navigator.pop(context);
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
              ));
    }

    void viewReport() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(report.name + " " + report.date),
                actions: [
                  ElevatedButton(
                    // open report in pdf
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              CreatePdf(report.ownerUid, report.reportUid));
                    },
                    child: Icon(Icons.article_outlined),
                    style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                  ),
                  ElevatedButton(
                      // open the report related photos
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => PhotoViewer(report.reportUid));
                      },
                      child: Icon(Icons.collections),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.red[500])),
                  ElevatedButton(
                      // delete report and photos.
                      onPressed: () {
                        print("delete");
                        _removeButton();
                        // Navigator.pop(context);
                      },
                      child: Icon(Icons.delete_forever),
                      style: ElevatedButton.styleFrom(primary: Colors.red[500]))
                ],
              ));
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
          title: Text(report.date),
          subtitle: Text(report.name),
          onTap: () {
            viewReport();
          },
        ),
        color: Colors.grey[400],
      ),
    );
  }
}
