import 'package:flutter/material.dart';
import 'package:B.E.E/pages/home/profile_bar.dart';
// import 'package:B.E.E/pages/home/drawer.dart';
import 'package:B.E.E/pages/home/profile_Settings.dart';
import 'package:B.E.E/pages/report_form/report_form_page.dart';
import 'package:B.E.E/pages/shared/constants.dart';
import 'package:B.E.E/services/auth.dart';
import 'package:B.E.E/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return profileSettings(_auth, context);
          });
    }

    return MultiProvider(
      providers: [
        StreamProvider(
            create: (BuildContext context) =>
                DatabaseService(uid: _auth.getUid()).assignments()),
        StreamProvider(
            create: (BuildContext context) =>
                DatabaseService(uid: _auth.getUid()).getCurrentUserDetails())
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          title:
              // Expanded(
              //   child:
              Text(
            'Main Page test 1:',
            style: TextStyle(color: Colors.white),
          ),
          // ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () => _showSettingsPanel()),
          ],
        ),
        // drawer: Drawer(
        //     child: DrawerWidgets(
        //   homeContext: context,
        // )),
        body: Column(children: <Widget>[
          SizedBox(
            height: boxSize,
          ),
          Container(color: Colors.red[500], child: ProfileBar()),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
