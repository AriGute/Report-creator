import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home/report_form/base_report.dart';
import 'package:save_pdf/pages/home/report_form/form_attributes.dart';
import 'package:save_pdf/pages/models/assignment.dart';
import 'package:save_pdf/pages/models/base_form.dart';
import 'package:save_pdf/services/auth.dart';
import 'package:save_pdf/services/database.dart';

class ReportForm extends StatefulWidget {
  Assignment assigment;
  List<Widget> widgetList = [];
  ReportForm({this.assigment});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  BaseForm report;
  Widget reportExpend;

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
            //TODO: async function for uploading the report.
            print("Save report.");
            Navigator.pop(context);
          }),
    );
  }

  Future setReport() async {
    List<Widget> widgets = FormAttributes().getFullWidgetList();
    if (widget.assigment == null) {
      // create full report(all widgets are available)
      setState(() {
        widget.widgetList = widgets;
      });
    } else {
      // create report accordin to assigment instructions
      Map instructions = await DatabaseService(uid: AuthService().getUid())
          .getAssignment(widget.assigment.uid);
      // get a map without the keys: 'date' and 'subject'(contain only widget names from form attributes)
      Map widgetInstructions = {};
      for (String key in instructions.keys) {
        if (key != "date" && key != "subject") {
          widgetInstructions[key] = instructions[key];
        }
      }
      setState(() {
        List<Widget> widgets =
            FormAttributes().getCustomWidgetList(widgetInstructions);
        widget.widgetList = widgets;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    report = new BaseForm();
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
        child: Column(children: [
          BaseReport(report: report),
          Container(
              alignment: Alignment.topRight,
              child: Column(children: widget.widgetList)),
          reportExpend,
          _saveBottun(),
        ]),
      ),
    ));
  }
}
