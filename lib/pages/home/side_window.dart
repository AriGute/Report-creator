import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/home/create_assignment/create_assignment_form.dart';

class SideWindows extends StatefulWidget {
  List<Widget> widgetList = [];
  final BuildContext homeContext;
  SideWindows({this.homeContext});
  bool isDeployed = false;
  @override
  _SideWindowsState createState() => _SideWindowsState();
}

class _SideWindowsState extends State<SideWindows> {
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

  @override
  Widget build(BuildContext context) {
    Future setWidgets() async {
      final Map userDetails = Provider.of<DocumentSnapshot>(context).data();

      widget.widgetList.add(setTextButton(() {
        // TODO: move to new frame with all the report for the current user
        print("testing button");
      }, "Reports"));
      if (userDetails["is_manager"]) {
        widget.widgetList.add(setTextButton(() {
          Navigator.push(
            widget.homeContext,
            MaterialPageRoute(builder: (context) => AssignmentForm()),
          );
        }, "Create assignment"));
      }

      widget.isDeployed = true;
      setState(() {});
    }

    if (!widget.isDeployed) {
      setWidgets();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
      ),
      body: ListView(
        children: [Container(child: Column(children: widget.widgetList))],
      ),
    );
  }
}
