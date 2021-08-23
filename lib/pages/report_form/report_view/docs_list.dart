import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CreateReport/pages/report_form/report_view/report_tile.dart';
import 'package:CreateReport/pages/models/report.dart';
import 'package:CreateReport/pages/shared/loading.dart';
import 'package:intl/intl.dart';

class DocsList extends StatefulWidget {
  @override
  _DocsListState createState() => _DocsListState();
}

class _DocsListState extends State<DocsList> {
  Widget docs;
  Widget getWidget(List<Report> reportList) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    reportList
        .sort((a, b) => format.parse(b.date).compareTo(format.parse(a.date)));
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

  dynamic lastItem;
  Future waitForLast(List<Report> reportList) async {
    lastItem = reportList.last;
    return getWidget;
  }

  @override
  Widget build(BuildContext context) {
    final reportList = Provider.of<List<Report>>(context);
    return reportList == null
        ? Loading()
        : reportList == null
            ? Loading()
            : getWidget(reportList);
  }
}
