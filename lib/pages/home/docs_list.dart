import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/models/report_tile.dart';
import 'package:save_pdf/pages/models/report.dart';
import 'package:save_pdf/pages/shared/loading.dart';

class DocsList extends StatefulWidget {
  Widget docs = Loading();
  @override
  _DocsListState createState() => _DocsListState();
}

class _DocsListState extends State<DocsList> {
  Future getWidget() async {
    final reportList = Provider.of<List<Report>>(context);
    if (reportList.length > 0) {
      widget.docs = ListView.builder(
          itemCount: reportList.length,
          itemBuilder: (context, index) {
            return ReportTile(report: reportList[index]);
          });
    } else {
      widget.docs = Text("No reports found.");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getWidget();
    return widget.docs;
  }
}
