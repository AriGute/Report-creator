import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_pdf/pages/shared/loading.dart';
import 'package:save_pdf/services/database.dart';

class ReportDisplay extends StatefulWidget {
  final String reportUid;
  final String ownerUid;
  ReportDisplay(this.ownerUid, this.reportUid);

  @override
  _ReportDisplayState createState() => _ReportDisplayState();
}

class _ReportDisplayState extends State<ReportDisplay> {
  DocumentSnapshot doc;
  List<Widget> report = [Loading()];

  Future fillReport() async {
    doc = await DatabaseService().getReport(widget.ownerUid, widget.reportUid);
    report = [];
    String title = "";
    doc.data().forEach((key, value) {
      if (key == "date") {
        report.insert(0, Text(key + ": " + value));
      } else if (key == "siteName") {
        title += key + ": " + value + ",  ";
      } else if (key == "weather") {
        title += key + ": " + value + ",  ";
      } else if (key == "logo") {
        title += key + ": " + value + ",  ";
      } else {
        report.add(Text(key + ": " + value));
      }
    });
    report.insert(0, Text(title));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fillReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text(
          "Report display:",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: report),
    );
  }
}
