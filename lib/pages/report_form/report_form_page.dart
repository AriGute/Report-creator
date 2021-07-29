import 'package:B.E.E/pages/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:B.E.E/pages/report_form/base_report.dart';
import 'package:B.E.E/pages/models/assignment.dart';
import 'package:B.E.E/pages/models/base_form.dart';
import 'package:B.E.E/pages/shared/loading.dart';
import 'package:B.E.E/services/auth.dart';
import 'package:B.E.E/services/database.dart';

class ReportForm extends StatefulWidget {
  final Assignment assigment;
  ReportForm({this.assigment});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final AuthService _auth = AuthService();
  final DatabaseService db = DatabaseService();
  BaseForm baseReport;
  List<Widget> widgetList = [Loading()];

  // for each subset item, if item is true then show its content
  Map<String, bool> subSetCheck = {};
  // subsets content
  Map<String, dynamic> subsetContent = {};

  Widget reportExpend;
  Map<String, dynamic> report = {};
  bool readyToBeSave = true;

  void _saveFunction() {
    if (widget.assigment != null) {
      DatabaseService().deletAssignments(_auth.getUid(), widget.assigment.uid);
    }
    initBaseReport();
    print("report :: " + report.toString());
    DatabaseService(uid: _auth.getUid()).addReport(report);
    Navigator.pop(context);
  }

  void _saveReport() {
    print("start saving");
    readyToBeSave = true;
    report.forEach((key, val) {
      print("checking1");
      print(val);
      if (val == "") {
        readyToBeSave = false;
      }
    });
    print("check if ready to be saved");

    if (readyToBeSave) {
      _saveFunction();
    } else {
      print("cant save rigth now");
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Some field are empty.\nContinue saving process?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _saveFunction();
                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                    style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                      style: ElevatedButton.styleFrom(primary: Colors.red[500]))
                ],
              ),
          barrierDismissible: false);
    }
  }

  Widget _saveBottun() {
    return Container(
      alignment: Alignment.topRight,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red[500],
            primary: Colors.white,
          ),
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            try {
              _saveReport();
            } on Exception catch (e) {
              // should skip save phase if throw exeption.
              SnackBar(
                backgroundColor: Colors.red[800],
                content: Text(
                  "Error, could not delet the assignment before creating new report.",
                  style: TextStyle(color: Colors.white),
                ),
              );
              print(e);
            }
          }),
    );
  }

  // Convert DateTime to string
  String dateFormat(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  void initBaseReport() {
    report["date"] = dateFormat(baseReport.selectedDate);
    report["siteName"] = baseReport.siteName;
    report["logo"] = baseReport.logo;
    report["weather"] = baseReport.weather;
  }

  Widget makeCardWidget(String subject) {
    return Column(
      children: [
        Container(
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  subject,
                  style: TextStyle(color: Colors.black),
                ))),
        TextFormField(
          decoration: textIputDecoration.copyWith(hintText: "Empty."),
          initialValue: report[subject],
          maxLines: 3,
          onChanged: (val) {
            report[subject] = val;
            if (val == "") {
              report.remove(subject);
            }
            print(report);
          },
        )
      ],
    );
  }

  Future setReport() async {
    List<Widget> tempWidgetList = [];
    initBaseReport();
    Map<String, bool> tempSubSetsChecker = {};
    Map<String, dynamic> tempSubSetsContent = {};

    QuerySnapshot qss = await db.getForm();
    qss.docs.forEach((item) {
      Map<String, dynamic> subset = item.data();
      Map<String, dynamic> content = subset["content"];
      tempSubSetsChecker[subset["name"]] = false;
      tempSubSetsContent[subset["name"]] = content;

      List<Widget> contentWidgetList = [];
      content.forEach((key, value) {
        contentWidgetList.add(makeCardWidget(key));
      });

      tempWidgetList.add(ExpansionTile(
        title: Row(children: [
          Icon(Icons.align_horizontal_left),
          Text(subset["name"])
        ]),
        maintainState: true,
        onExpansionChanged: (val) => tempSubSetsChecker[subset["name"]] = val,
        children: contentWidgetList,
      ));
      tempWidgetList.add(Divider(color: Colors.grey));
    });

    setState(() {
      subSetCheck = tempSubSetsChecker;
      subsetContent = tempSubSetsContent;
      widgetList = tempWidgetList;
    });
  }

  @override
  void initState() {
    super.initState();
    baseReport = new BaseForm();
    reportExpend = Text("");
    setReport();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text(
          "Create Report:",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(children: [
          BaseReport(report: baseReport),
          Container(
              alignment: Alignment.topRight,
              child: Column(children: widgetList)),
          reportExpend,
          _saveBottun(),
        ]),
      ),
    ));
  }
}
