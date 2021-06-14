// import 'dart:io';
// import 'package:flutter/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:open_file/open_file.dart';
// import 'package:save_pdf/pages/shared/loading.dart';
// import 'package:save_pdf/services/database.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// // ignore: must_be_immutable
// class CreatePdf extends StatelessWidget {
//   final String reportUid;
//   final String ownerUid;
//   CreatePdf(this.ownerUid, this.reportUid);

//   DocumentSnapshot doc;
//   final document = PdfDocument();
//   List<Widget> report = [Loading()];
//   List<String> reportAttributes = [];
//   Map<String, String> reportDetails = {};

//   Future<void> _saveAndLunchFile(List<int> bytes, String fileName) async {
//     final path = (await getApplicationDocumentsDirectory()).path;
//     final file = File("${path}/${fileName}");
//     await file.writeAsBytes(bytes, flush: true);
//     final results = OpenFile.open('${path}/${fileName}');
//   }

//   void _buildReport(Map<String, String> details, List<String> attributes) {
//     final page = document.pages.add();
//     final PdfGraphics graphics = page.graphics;
//     final font = PdfStandardFont(PdfFontFamily.helvetica, 30);
//     final PdfGrid grid = PdfGrid();

//     print(details["siteName"]);
//     print(page);
//     print(page);
//     print(font);
//     report = [];
//     page.graphics.drawString("Site name: " + details["siteName"], font);
//     page.graphics.drawString("\nDate: " + details["date"],
//         PdfStandardFont(PdfFontFamily.helvetica, 25));
//   }

//   Future<void> createFile() async {
//     doc = await DatabaseService().getReport(ownerUid, reportUid);
//     report = [];
//     String title = "";
//     doc.data().forEach((key, value) {
//       if (key == "date") {
//         reportDetails[key] = value;
//       } else if (key == "siteName") {
//         reportDetails[key] = value;
//       } else if (key == "weather") {
//         reportDetails[key] = value;
//       } else if (key == "logo") {
//         reportDetails[key] = value;
//       } else {
//         reportAttributes.add(key + ": " + value);
//       }
//     });

//     String fileName = reportDetails['siteName'] +
//         ' ' +
//         reportDetails['date'].replaceAll('/', '.') +
//         '.pdf';
//     fileName = "text.pdf";
//     List<int> bytes = document.save();
//     document.dispose();

//     print(doc.data());
//     print(reportDetails);
//     print(reportAttributes);

//     _buildReport(reportDetails, reportAttributes);
//     _saveAndLunchFile(bytes, fileName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("work?");
//     createFile();
//     Navigator.pop(context);
//     return Container();
//   }
// }
