import 'dart:io';
import 'dart:typed_data';
import 'package:CreateReport/pages/shared/loading.dart';
import 'package:CreateReport/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class CreatePdf extends StatefulWidget {
  final String reportUid;
  final String ownerUid;
  CreatePdf(this.ownerUid, this.reportUid);
  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdf> {
  final DatabaseService db = DatabaseService();

  DocumentSnapshot doc;
  List<String> reportAttributes = [];
  Map<String, String> reportDetails = {};

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
    Navigator.pop(context);
  }

  Future<Uint8List> _loadFont(String path) async {
    ByteData data = await rootBundle.load(path);
    Uint8List font =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    return font;
  }

  void _buildReport(
      Map<String, String> details, List<String> attributes) async {
    final pdf = pw.Document();
    final Uint8List regularFontData =
        await _loadFont("lib/fonts/Alef-Regular.ttf");
    final ttf = pw.Font.ttf(regularFontData.buffer.asByteData());
    final Uint8List boldFontData = await _loadFont("lib/fonts/Alef-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldFontData.buffer.asByteData());

    // page content
    List<pw.Widget> pageContent = [];

    // add headline
    pageContent.add(await buildHeadLine(reportDetails["date"]));

    // add site name
    pageContent.add(pw.Container(
        child: pw.Text(
            reportDetails["siteName"].replaceFirst(reportDetails["siteName"][0],
                reportDetails["siteName"][0].toUpperCase()),
            style: pw.TextStyle(fontSize: 30, font: ttfBold)),
        alignment: pw.Alignment.topCenter));

    // add table title
    pageContent.add(pw.Container(
        decoration: pw.BoxDecoration(color: PdfColors.grey200),
        child: pw.Text("Technical details",
            style: pw.TextStyle(fontSize: 15, font: ttfBold)),
        alignment: pw.Alignment.topCenter));

    // table for report attribute
    List<pw.TableRow> tableRows = [];
    pw.Table table = pw.Table(children: tableRows);

    int attributeIndex = 0;
    attributes.forEach((item) {
      tableRows.add(buildParagraph(item, ttf, attributeIndex));
      attributeIndex++;
    });
    pageContent.add(table);

    // add to page
    pdf.addPage(pw.MultiPage(
        build: (context) => pageContent,
        footer: (context) {
          final text = "Page ${context.pageNumber} of ${context.pagesCount}";
          return pw.Container(
              alignment: pw.Alignment.centerRight, child: pw.Text(text));
        }));

    final String fileName = reportDetails['siteName'] + '.pdf';
    final List<int> bytes = await pdf.save();
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File("$path/$fileName");
    await file.writeAsBytes(bytes, flush: true);
    await OpenFile.open(file.path);
  }

  Future<pw.SvgImage> buildImg() async {
    String str = await rootBundle.loadString("lib/assets/logo.png");
    return pw.SvgImage(svg: str);
  }

  Future<pw.Header> buildHeadLine(String date) async {
    // load B.E.E logo
    pw.Image logo = pw.Image(
        pw.MemoryImage(
          (await rootBundle.load('lib/assets/logo.png')).buffer.asUint8List(),
        ),
        height: 50.0,
        width: 50.0);
    pw.Header header = pw.Header(
        child: pw.Row(children: [
          pw.Center(child: logo),
          pw.Text(" Report Creator",
              style: pw.TextStyle(fontSize: 24, color: PdfColors.white)),
          pw.SizedBox(width: 9 * PdfPageFormat.cm),
          pw.Container(
            child: pw.Text(" " + date,
                style: pw.TextStyle(fontSize: 24, color: PdfColors.white)),
          )
        ]),
        decoration: pw.BoxDecoration(color: PdfColors.red));
    return header;
  }

  pw.TableRow buildParagraph(String text, pw.Font font, int index) {
    List<String> splitText = text.split(':');
    pw.TableRow tableRow = pw.TableRow(children: [
      pw.Center(
          child:
              pw.Text(index.toString() + ")", style: pw.TextStyle(font: font))),
      pw.Center(child: pw.Text(splitText[0], style: pw.TextStyle(font: font))),
      pw.Center(child: pw.Text(splitText[1], style: pw.TextStyle(font: font)))
    ]);
    return tableRow;
  }

  @override
  void initState() {
    super.initState();
    _fillReport();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(width: 10.0, height: 100, child: Loading()),
    );
  }
}
