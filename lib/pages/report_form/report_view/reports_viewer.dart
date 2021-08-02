import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:B.E.E/pages/report_form/report_view/docs_list.dart';
import 'package:B.E.E/services/auth.dart';
import 'package:B.E.E/services/database.dart';

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
