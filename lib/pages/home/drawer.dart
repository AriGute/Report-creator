import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/home/create_assignment/create_assignment_form.dart';
import 'package:save_pdf/pages/home/report_form/reports_viewer.dart';

/*
DrawerWidgets return a container to fill the drawer in the main page.
Show different container depend on the current logged user(manager/worker)
*/
class DrawerWidgets extends StatefulWidget {
  final BuildContext homeContext;
  DrawerWidgets({this.homeContext});
  // bool isDeployed = false;
  @override
  _DrawerWidgetsState createState() => _DrawerWidgetsState();
}

class _DrawerWidgetsState extends State<DrawerWidgets> {
  ButtonStyle buttonStyle = TextButton.styleFrom(
    backgroundColor: Colors.red[500],
    primary: Colors.white,
  );

  Container setTextButton(Function func, String text) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: buttonStyle,
        onPressed: func,
        child: Text(text),
      ),
    );
  }

  List<Widget> setWidgets(userDetails) {
    List<Widget> widgetList = [];
    widgetList.add(setTextButton(() {
      Navigator.push(
        widget.homeContext,
        MaterialPageRoute(builder: (context) => ReportViewer()),
      );
    }, "Reports"));
    if (userDetails["is_manager"]) {
      widgetList.add(setTextButton(() {
        Navigator.push(
          widget.homeContext,
          MaterialPageRoute(builder: (context) => AssignmentForm()),
        );
      }, "Create assignment"));
    }
    print("finish set widgets");
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    final Map userDetails = Provider.of<DocumentSnapshot>(context).data();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
      ),
      body: ListView(
        children: [Container(child: Column(children: setWidgets(userDetails)))],
      ),
    );
  }
}
