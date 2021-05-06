import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home/docs_list.dart';
import 'package:save_pdf/pages/home/report_form/report_form_page.dart';
import 'package:save_pdf/pages/home/settings_form.dart';
import 'package:save_pdf/pages/models/report.dart';
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
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Report>>.value(
      value: DatabaseService(uid: _auth.getUid()).docs(),
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          title: Text(
            'Main Page:',
            style: TextStyle(color: appBarTextColor),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.person,
                color: appBarTextColor,
              ),
              label: Text(
                'Log out',
                style: TextStyle(color: appBarTextColor),
              ),
            ),
            FlatButton.icon(
              onPressed: () => _showSettingsPanel(),
              icon: Icon(
                Icons.settings,
                color: appBarTextColor,
              ),
              label: Text(
                'Settings',
                style: TextStyle(color: appBarTextColor),
              ),
            )
          ],
        ),
        body: DocsList(),
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
