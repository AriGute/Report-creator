import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home/docs_list.dart';
import 'package:save_pdf/pages/home/profile_bar.dart';
import 'package:save_pdf/pages/home/report_form/report_form_page.dart';
import 'package:save_pdf/pages/home/side_window.dart';
import 'package:save_pdf/pages/models/report.dart';
import 'package:save_pdf/pages/profile_Settings.dart';
import 'package:save_pdf/pages/shared/constants.dart';
import 'package:save_pdf/services/auth.dart';
import 'package:save_pdf/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Color appBarTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return profileSettings(_auth, context);
          });
    }

    return StreamProvider<List<Report>>.value(
      value: DatabaseService(uid: _auth.getUid()).docs(),
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          title: Expanded(
            child: Text(
              'Main Page:',
              style: TextStyle(color: appBarTextColor),
            ),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: appBarTextColor,
                ),
                onPressed: () => _showSettingsPanel()),
          ],
        ),
        drawer: Drawer(child: sideWindows()),
        body: Column(children: <Widget>[
          SizedBox(
            height: boxSize,
          ),
          Container(
              color: Colors.red[500],
              child: ProfileBar(
                  userDetails:
                      DatabaseService(uid: _auth.getUid()).getUserDetails())),
          Expanded(child: DocsList())
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("add report");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportForm()),
            );
          },
          child: Icon(
            Icons.add_comment_outlined,
          ),
          backgroundColor: Colors.red[500],
          elevation: 0.0,
        ),
      ),
    );
  }
}
