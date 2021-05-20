import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/home/report_form/form_attributes.dart';
import 'package:save_pdf/services/database.dart';

class AssignmentForm extends StatefulWidget {
  FormAttributes assigmentList = new FormAttributes();
  List<Widget> switchList = [];
  List usersList = [];

  // each item in switchMap is indicator for if widget should be exist in assigment
  Map swtichMap = {};

  String targetName = "chose";
  String selctedUid = "";
  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
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

  // get a list of users from stream of QuerySnapShot from user collection
  Future<List> getUsers() async {
    Stream<QuerySnapshot> queryStream = DatabaseService().getUserCollection();
    queryStream.listen((qss) {
      qss.docs.forEach((doc) async {
        Map queryStream = await DatabaseService().getUserDetails(doc.id);
        Map user = queryStream;
        user["uid"] = doc.id;
        widget.usersList.add(queryStream);
        widget.usersList.sort((a, b) {
          return a['first_name']
              .toLowerCase()
              .compareTo(b['first_name'].toLowerCase());
        });
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    getUsers();
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

    widget.switchList.add(TextButton(
        onPressed: () {
          print("selected uid: ${widget.selctedUid}");
          print(widget.swtichMap.values.toList());
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
