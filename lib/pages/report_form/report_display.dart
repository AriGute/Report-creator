import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:save_pdf/pages/shared/loading.dart';
import 'package:save_pdf/services/database.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ReportDisplay extends StatefulWidget {
  final String reportUid;
  final String ownerUid;
  ReportDisplay(this.ownerUid, this.reportUid);

  @override
  _ReportDisplayState createState() => _ReportDisplayState();
}

class _ReportDisplayState extends State<ReportDisplay> {
  DocumentSnapshot doc;
  PdfDocument document = PdfDocument();
  List<Widget> report = [Loading()];
  List<String> reportAttributes = [];
  Map<String, String> reportDetails = {};

  Future<void> _saveAndLunchFile(List<int> bytes, String fileName) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File("${path}/${fileName}");
    await file.writeAsBytes(bytes, flush: true);
    final results = OpenFile.open('${path}/${fileName}');
  }

  Future<void> _createFile() async {
    String fileName = reportDetails['siteName'] +
        ' ' +
        reportDetails['date'].replaceAll('/', '.') +
        '.pdf';
    fileName = "text.pdf";
    List<int> bytes = document.save();
    document.dispose();
    _saveAndLunchFile(bytes, fileName);
  }

  //  Split to report details(site name, date, etc) and all the rest(insperts/form attributes).
  Future _fillReport() async {
    doc = await DatabaseService().getReport(widget.ownerUid, widget.reportUid);
    report = [];
    String title = "";
    doc.data().forEach((key, value) {
      if (key == "date") {
        reportDetails[key] = value;
      } else if (key == "siteName") {
        reportDetails[key] = value;
      } else if (key == "weather") {
        reportDetails[key] = value;
      } else if (key == "logo") {
        reportDetails[key] = value;
      } else {
        reportAttributes.add(key + ": " + value);
      }
    });
    _buildReport(reportDetails, reportAttributes);
    // _createFile();
    setState(() {});
  }

  // Build a list of widget that look like a doc file
  void _buildReport(Map<String, String> details, List<String> attributes) {
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final font = PdfStandardFont(PdfFontFamily.helvetica, 30);
    final PdfGrid grid = PdfGrid();

    report = [];
    page.graphics.drawString("Site name: " + details["siteName"], font);
    page.graphics.drawString("\nDate: " + details["date"],
        PdfStandardFont(PdfFontFamily.helvetica, 25));

    report.add(Row(
      children: [
        Expanded(
            child:
                Text("Logo: " + details["logo"], textAlign: TextAlign.start)),
        Expanded(child: Text(details["date"], textAlign: TextAlign.end))
      ],
    ));
    report.add(SizedBox(
      height: 10,
    ));
    report.add(Row(children: [
      Expanded(
          child: Text("Site name: " + details["siteName"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center)),
    ]));
    report.add(SizedBox(
      height: 10,
    ));
    report.add(Divider(
      color: Colors.grey[850],
      thickness: 3,
    ));
    report.add(Row(
      children: [
        Expanded(
            child: Text("List of inspections:",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
      ],
    ));

    report.add(Divider(
      color: Colors.grey[850],
      thickness: 3,
    ));

    report.add(Row(
      children: [
        Expanded(
            child: Text("Weather condition: ",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(details["weather"], textAlign: TextAlign.start)),
      ],
    ));

    report.add(Divider(color: Colors.grey));

    attributes.forEach((inspc) {
      List<String> keyAndVal = inspc.split(':');
      report.add(Row(
        children: [
          Expanded(
              child: Text(
            keyAndVal[0] + ":",
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(child: Text(keyAndVal[1], textAlign: TextAlign.start)),
        ],
      ));
      report.add(Divider(color: Colors.grey));
    });
  }

  @override
  void initState() {
    super.initState();
    _fillReport();
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
        actions: [
          IconButton(
              icon: Icon(Icons.file_present), onPressed: () => _createFile())
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: report),
    );
  }
}
