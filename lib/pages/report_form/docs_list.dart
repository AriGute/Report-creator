import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/report_form/report_tile.dart';
import 'package:save_pdf/pages/models/report.dart';
import 'package:save_pdf/pages/shared/loading.dart';

class DocsList extends StatefulWidget {
  @override
  _DocsListState createState() => _DocsListState();
}

class _DocsListState extends State<DocsList> {
  Widget docs;
  Widget getWidget(List<Report> reportList) {
    if (reportList.length > 0) {
      docs = ListView.builder(
          itemCount: reportList.length,
          itemBuilder: (context, index) {
            return ReportTile(report: reportList[index]);
          });
      return docs;
    } else {
      return Text("No reports found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportList = Provider.of<List<Report>>(context);
    return reportList == null ? Loading() : getWidget(reportList);
  }
}
