import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_pdf/pages/shared/form_attributes.dart';
import 'package:save_pdf/pages/shared/constants.dart';
import 'package:save_pdf/pages/shared/loading.dart';
import 'package:save_pdf/services/database.dart';

class AssignmentForm extends StatefulWidget {
  FormAttributes assigmentList = new FormAttributes();
  // list for each switch that suppost to be on the screen
  List<Widget> switchList = [Loading()];
  // list of user that for assigment attachment
  List usersList = [];
  // assigment subject
  String subject = '';
  // each item in switchMap is indicator for if widget should be exist in assigment
  Map<String, bool> swtichMap = {};
  // selected user for the assigment attachment
  String targetName = "Chose worker";
  // selected user id
  String selctedUid = "";

  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _formKey = GlobalKey<FormState>();

  // create switch (get string as name/purpose of the switch)
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

  Future<List> getUsers() async {
    QuerySnapshot qs = await DatabaseService().getUsers();
    qs.docs.forEach((doc) {
      widget.usersList.add(doc.data());
    });
    widget.usersList.sort((a, b) {
      return a['first_name']
          .toLowerCase()
          .compareTo(b['first_name'].toLowerCase());
    });
  }

  Future initAssignmentForm() async {
    getUsers();

    Map widgetMap = await FormAttributes().getWidgetMap();
    widget.switchList = [];
    widget.switchList = widgetMap.keys.map((k) => getSwitch(k)).toList();

    widget.switchList.add(DropdownButtonFormField<String>(
      validator: (val) => widget.selctedUid.length == 0
          ? 'Select a worker to attach him the assignment'
          : null,
      isExpanded: true,
      hint: Text(widget.targetName),
      items: widget.usersList.map((value) {
        return new DropdownMenuItem<String>(
          value: value["first_name"] +
              " " +
              value["last_name"] +
              " |" +
              value["email"],
          child: new Text(value["first_name"] +
              " " +
              value["last_name"] +
              " |" +
              value["email"]),
        );
      }).toList(),
      onChanged: (pick) {
        setState(() {
          widget.targetName = pick;
          widget.usersList.forEach((user) {
            if (pick.split("|")[1] == user["email"]) {
              widget.selctedUid = user["uid"];
            }
          });
        });
      },
    ));

    widget.switchList.add(TextFormField(
      decoration: textIputDecoration.copyWith(hintText: 'subject'),
      validator: (val) => val.isEmpty ? 'Enter an subject' : null,
      onChanged: (val) {
        widget.subject = val;
      },
    ));

    widget.switchList.add(TextButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (widget.selctedUid.length > 0) {
              DatabaseService().addAssigment(
                  widget.selctedUid, widget.swtichMap, widget.subject);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red[800],
                content: Text(
                  "Assigment created",
                  style: TextStyle(color: Colors.white),
                ),
              ));
              Navigator.pop(context);
            }
          }
        },
        child: Text("Assign")));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initAssignmentForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create assigment"),
          backgroundColor: Colors.red[500],
        ),
        body:
            Form(key: _formKey, child: ListView(children: widget.switchList)));
  }
}
