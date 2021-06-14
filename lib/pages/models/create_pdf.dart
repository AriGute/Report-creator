import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:save_pdf/pages/shared/loading.dart';
import 'package:save_pdf/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// ignore: must_be_immutable
class CreatePdf extends StatefulWidget {
  final String reportUid;
  final String ownerUid;
  CreatePdf(this.ownerUid, this.reportUid);

  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdf> {
  DocumentSnapshot doc;
  PdfDocument document = PdfDocument();
  List<String> reportAttributes = [];
  Map<String, String> reportDetails = {};

  Future<void> _saveAndLunchFile(List<int> bytes, String fileName) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File("${path}/${fileName}");
    await file.writeAsBytes(bytes, flush: true);
    final results = OpenFile.open('${path}/${fileName}');
  }

  Future<void> _createFile() async {
    print("date!!!!!!");

    String date = reportDetails['date'];
    if (date != null) {
      date = date.replaceAll('/', '.');
    }
    String siteName = reportDetails['siteName'];
    if (siteName != null) {
      String fileName = siteName + ' ' + date + '.pdf';

      List<int> bytes = document.save();
      document.dispose();
      _saveAndLunchFile(bytes, fileName);
      Navigator.pop(context);
    }
  }

  //  Split to report details(site name, date, etc) and all the rest(insperts/form attributes).
  Future _fillReport() async {
    doc = await DatabaseService().getReport(widget.ownerUid, widget.reportUid);
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
    setState(() {});
  }

  // Build a list of widget that look like a doc file
  void _buildReport(Map<String, String> details, List<String> attributes) {
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final font = PdfStandardFont(PdfFontFamily.helvetica, 30);
    final PdfGrid grid = PdfGrid();

    page.graphics.drawString("Site name: " + details["siteName"], font);
    page.graphics.drawString("\nDate: " + details["date"],
        PdfStandardFont(PdfFontFamily.helvetica, 25));
  }

  @override
  void initState() {
    super.initState();
    _fillReport();
  }

  @override
  Widget build(BuildContext context) {
    _createFile();
    return AlertDialog(
      content: Container(width: 10.0, height: 100, child: Loading()),
    );
  }
}
