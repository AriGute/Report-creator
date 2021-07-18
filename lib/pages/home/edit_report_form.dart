import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:B.E.E/pages/shared/constants.dart';
import 'package:B.E.E/pages/shared/loading.dart';
import 'package:B.E.E/services/database.dart';

class EditReportForm extends StatefulWidget {
  @override
  _EditReportFormState createState() => _EditReportFormState();
}

class _EditReportFormState extends State<EditReportForm> {
  Widget formListView = Loading();
  Map<String, String> reportFromMap = {};
  List<Widget> reportForm = [];

  // init the list view with a widget for each attribute in the ReportForm from the db.
  Future initReportFormMap() async {
    formListView = Loading();
    setState(() {});
    try {
      DocumentSnapshot rf = await DatabaseService().getReportForm();
      reportFromMap = {};
      reportForm = [];

      rf.data().keys.forEach((key) {
        reportFromMap[key] = key;
        if (key == "new") {
          reportForm.insert(0, getAttribute(key));
        } else {
          reportForm.add(getAttribute(key));
        }
      });
      reportForm.add(ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red[500]),
        onPressed: () {
          print("add new attribute");
          String key = "new";
          if (reportFromMap[key] == null) {
            reportFromMap[key] = key;
            DatabaseService().setReportForm(reportFromMap.values.toList());
            initReportFormMap();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red[800],
              content: Text(
                "There is alredy a new attribute, change it, save the report form and then create new attribute.",
                style: TextStyle(color: Colors.white),
              ),
            ));
          }
        },
        child: Text(
          "Add new form attribute",
          style: TextStyle(color: Colors.white),
        ),
      ));
      reportForm.add(ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red[500]),
        onPressed: () {
          DatabaseService().setReportForm(reportFromMap.values.toList());
          initReportFormMap();
        },
        child: Text(
          "Save report form",
          style: TextStyle(color: Colors.white),
        ),
      ));
      setState(() {
        formListView = ListView(shrinkWrap: true, children: reportForm);
      });
    } catch (e) {
      Navigator.pop(context);
      print("Error " + e.toString());
    }
  }

  // create new list from the original list but with out the givin key and update the ReportForm in the db.
  void removeAttribute(String key) {
    List newList = [];
    reportFromMap.keys.forEach((k) {
      if (k != key) {
        newList.add(k);
      }
    });
    DatabaseService().setReportForm(newList);
    initReportFormMap();
  }

  Widget getAttribute(String key) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            decoration: textIputDecoration.copyWith(hintText: key),
            onChanged: (val) {
              reportFromMap[key] = val;
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.red[500],
              ),
              onPressed: () {
                String myKey = key;
                print("Remove ${myKey} from the report form.");
                removeAttribute(myKey);
              }),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initReportFormMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          title: Text(
            "Edit report form:",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: formListView);
  }
}
