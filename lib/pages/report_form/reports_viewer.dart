import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/report_form/docs_list.dart';
import 'package:save_pdf/services/auth.dart';
import 'package:save_pdf/services/database.dart';

class ReportViewer extends StatefulWidget {
  ReportViewer();

  @override
  _ReportViewerState createState() => _ReportViewerState();
}

class _ReportViewerState extends State<ReportViewer> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (BuildContext context) =>
                DatabaseService(uid: _auth.getUid()).docs()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Reports:",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[500],
        ),
        body: DocsList(),
      ),
    );
  }
}
