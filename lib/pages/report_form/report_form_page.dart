import 'package:flutter/material.dart';
import 'package:B.E.E/pages/report_form/base_report.dart';
import 'package:B.E.E/pages/shared/form_attributes.dart';
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
  BaseForm baseReport;

  Widget reportExpend;
  List<Widget> widgetList = [Loading()];
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

  Future setReport() async {
    List<Widget> widgets = [];
    // TODO: full report not save attributes
    Map widgetInstructions = {};
    Map instructions = {};
    widgetList = [];
    initBaseReport();
    if (widget.assigment == null) {
      /* 
      Create full report(all widgets are available).
      Get the full widget map and for each key create a representor(instructions[key] = true)
      */
      await FormAttributes()
          .getWidgetMap()
          .then((value) => value.forEach((key, value) {
                instructions[key] = true;
              }));
    } else {
      /*
      Create report accordin to assigment instructions.
      */
      instructions = await DatabaseService(uid: AuthService().getUid())
          .getAssignment(widget.assigment.uid);
    }
    for (String key in instructions.keys) {
      // Get a map without the keys: 'date' and 'subject'(contain only widget names from form attributes)
      if (key != "date" && key != "subject") {
        report[key] = "empty";
        widgetInstructions[key] = instructions[key];
      }
    }
    widgets = await FormAttributes(valuesMap: report)
        .getCustomWidgetList(widgetInstructions);
    print("finish waiting");
    setState(() {
      widgetList = widgets;
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
