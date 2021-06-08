import 'package:flutter/material.dart';
import 'package:save_pdf/pages/report_form/base_report.dart';
import 'package:save_pdf/pages/shared/form_attributes.dart';
import 'package:save_pdf/pages/models/assignment.dart';
import 'package:save_pdf/pages/models/base_form.dart';
import 'package:save_pdf/pages/shared/loading.dart';
import 'package:save_pdf/services/auth.dart';
import 'package:save_pdf/services/database.dart';

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

  void saveReport() {
    initBaseReport();
    DatabaseService(uid: _auth.getUid()).addReport(report);
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
            print(report);
            if (widget.assigment != null) {
              try {
                DatabaseService()
                    .deletReport(_auth.getUid(), widget.assigment.uid);
                saveReport();
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
            } else {
              saveReport();
            }

            Navigator.pop(context);
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
    List<Widget> widgets = await FormAttributes().getFullWidgetList();
    widgetList = [];
    initBaseReport();

    if (widget.assigment == null) {
      // create full report(all widgets are available)
      widgetList = await FormAttributes().getFullWidgetList();
      setState(() {});
    } else {
      // create report accordin to assigment instructions
      Map instructions = await DatabaseService(uid: AuthService().getUid())
          .getAssignment(widget.assigment.uid);
      // get a map without the keys: 'date' and 'subject'(contain only widget names from form attributes)
      Map widgetInstructions = {};
      for (String key in instructions.keys) {
        if (key != "date" && key != "subject") {
          report[key] = "empty";
          widgetInstructions[key] = instructions[key];
        }
      }
      List<Widget> widgets =
          await FormAttributes().getCustomWidgetList(widgetInstructions);
      setState(() {
        widgetList = widgets;
      });
    }
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
