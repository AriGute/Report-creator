import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportDisplay extends StatefulWidget {
  final String reportUid;
  final String ownerUid;
  ReportDisplay(this.ownerUid, this.reportUid);

  @override
  _ReportDisplayState createState() => _ReportDisplayState();
}

class _ReportDisplayState extends State<ReportDisplay> {
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
        //TODO: sohw report info based on the report uid and report owner uid
        //      and option to download as a pdf with PdfGenerator(and maybe even edit in this page?)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("report: " + widget.reportUid),
          SizedBox(),
          Text("woker: " + widget.ownerUid)
        ],
      ),
    );
  }
}
