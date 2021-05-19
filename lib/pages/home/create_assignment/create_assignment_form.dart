import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home/report_form/form_attributes.dart';
import 'package:save_pdf/services/database.dart';

class AssignmentForm extends StatefulWidget {
  FormAttributes assigmentList = new FormAttributes();
  List<Widget> switchList = [];
  Map swtichMap = {};
  String targetName = "chose";
  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  // Stream<QuerySnapshot> users = DatabaseService().db.snapshots();

  Widget getSwitch(String s) {
    if (widget.swtichMap[s] == null) {
      widget.swtichMap[s] = false;
    }
    return Container(
      child: Row(
        children: [
          Text(s + " "),
          Switch(
              value: widget.swtichMap[s],
              onChanged: (onChange) {
                widget.swtichMap[s] = onChange;
                setState(() {});
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.switchList = widget.assigmentList
        .getWidgetMap()
        .keys
        .map((k) => getSwitch(k))
        .toList();

    widget.switchList.add(DropdownButton<String>(
      isExpanded: true,
      hint: Text(widget.targetName),
      items: <String>['Solar power', 'ברק', 'נופר'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (pick) {
        print(pick);
        setState(() {
          widget.targetName = pick;
        });
      },
    ));
    widget.switchList.add(TextButton(
        onPressed: () {
          print(" s");
        },
        child: Text("test")));

    return Scaffold(
      appBar: AppBar(
        title: Text("Create assigment"),
        backgroundColor: Colors.red[500],
      ),
      body: Column(children: widget.switchList),
    );
  }
}
