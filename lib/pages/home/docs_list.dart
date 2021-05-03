import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/home/report_tile.dart';
import 'package:save_pdf/pages/models/report.dart';

class DocsList extends StatefulWidget {
  @override
  _DocsListState createState() => _DocsListState();
}

class _DocsListState extends State<DocsList> {
  @override
  Widget build(BuildContext context) {
    final reportList = Provider.of<List<Report>>(context);
    print('<[docs_list.dart => _DocsListState]>');
    if (reportList != null) {
      print("reports:  $reportList");

      reportList.forEach((report) {
        print(report.name);
        print(report.date);
        print(report.anotherThing);
      });
    } else {
      print('list is null');
    }
    return ListView.builder(
        itemCount: reportList.length,
        itemBuilder: (context, index) {
          return ReportTile(report: reportList[index]);
        });
  }
}
