import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:B.E.E/pages/shared/loading.dart';
import 'package:B.E.E/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CreatePdf extends StatefulWidget {
  final String reportUid;
  final String ownerUid;
  CreatePdf(this.ownerUid, this.reportUid);

  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdf> {
  DocumentSnapshot doc;
  final PdfDocument document = PdfDocument();
  List<String> reportAttributes = [];
  Map<String, String> reportDetails = {};

  Future<void> _saveAndLunchFile(List<int> bytes, String fileName) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File("${path}/${fileName}");
    await file.writeAsBytes(bytes, flush: true);
    final results = OpenFile.open('${path}/${fileName}');
  }

  Future<void> _createFile() async {
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
    print(doc.data());
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

  // Return the center length is needed as correspond to string lenght of the page.
  double centerPage(String text, Size pageSize) {
    return pageSize.width / 2 - 7 * text.length;
  }

  Future<Uint8List> _loadFont(String path) async {
    ByteData data = await rootBundle.load(path);
    Uint8List font =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return font;
  }

  // Build a list of widget that look like a doc file
  void _buildReport(
      Map<String, String> details, List<String> attributes) async {
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();
    Uint8List font = await _loadFont("lib/fonts/Alef-Regular.ttf");
    for (int i = 0; i < 5; i++) {
      if (font == null) {
        font = await _loadFont("lib/fonts/Alef-Regular.ttf");
      } else if (font != null) {
        break;
      } else {
        print("Could not get font, abort after 5 attemts.");
        return;
      }
    }

    // Create a PDF true type font object.
    final PdfFont pdfFont = PdfTrueTypeFont(font, 30);
    final PdfStringFormat pdfFormat = PdfStringFormat(
        textDirection: PdfTextDirection.rightToLeft,
        alignment: PdfTextAlignment.left,
        paragraphIndent: 10);

    PdfColor lightBlue = PdfColor(51, 171, 249);
    PdfColor black = PdfColor(0, 0, 0);

    // Add subject (site name).
    page.graphics.drawString("Site name: " + details["siteName"], pdfFont,
        format: pdfFormat,
        brush: PdfSolidBrush(black),
        bounds: Rect.fromLTWH(
            centerPage("Site name: " + details["siteName"], pageSize),
            50,
            pageSize.width,
            100));

    // Add log to the page.
    String logo = "Logo: " + details["logo"];
    page.graphics.drawString(logo, pdfFont,
        format: pdfFormat,
        brush: PdfSolidBrush(black),
        bounds: Rect.fromLTWH(0, 0, pageSize.width / 2, 50));

    // Add date to the page.
    page.graphics.drawString(
        details["date"], PdfStandardFont(PdfFontFamily.helvetica, 20),
        format: pdfFormat,
        brush: PdfSolidBrush(black),
        bounds: Rect.fromLTWH(pageSize.width - 100, 0, pageSize.width, 50));

    // Output each report attribute to the page.
    int counter = 0;
    double offset = 150;
    reportAttributes.forEach((item) {
      // Draw line between report attributes.
      page.graphics.drawLine(
          PdfPen(PdfColor(0, 0, 0), width: 2),
          Offset(0, offset + 50 * counter.toDouble()),
          Offset(pageSize.width, offset + 50 * counter.toDouble()));

      // Report attribute.
      String attribute = item;
      page.graphics.drawString(attribute, pdfFont,
          format: pdfFormat,
          brush: PdfSolidBrush(black),
          bounds: Rect.fromLTWH(0, offset + 50 * counter.toDouble(),
              pageSize.width, offset + 50 * counter.toDouble()));
      counter++;
    });

    // Draw line at the end of the page.
    page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 2),
        Offset(0, offset + 50 * counter.toDouble()),
        Offset(pageSize.width, offset + 50 * counter.toDouble()));
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
