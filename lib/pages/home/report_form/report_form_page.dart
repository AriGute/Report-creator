import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home/report_form/base_report.dart';
// import 'package:save_pdf/pages/home/report_form/five_years_report.dart';
// import 'package:save_pdf/pages/home/report_form/form_widget_list.dart';
// import 'package:save_pdf/pages/home/report_form/generator_report.dart';
// import 'package:save_pdf/pages/home/report_form/one_year_report.dart';
import 'package:save_pdf/pages/home/report_form/form_attributes.dart';
import 'package:save_pdf/pages/models/base_form.dart';

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  BaseForm report;
  Widget reportExpend;

  @override
  void initState() {
    super.initState();
    report = new BaseForm();
    reportExpend = Text("");
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
            //TODO: async function for uploading the report.
            print("Save report.");
            Navigator.pop(context);
          }),
    );
  }

  // Widget _expendFormButtom() {
  //   Color buttonColor = Colors.red[500];
  //   TextStyle textStyle = TextStyle(color: Colors.white);

  //   return Row(
  //     children: <Widget>[
  //       Expanded(
  //           child: FlatButton(
  //               color: buttonColor,
  //               onPressed: () {
  //                 setState(() {
  //                   reportExpend = GeneratorReport(report: report);
  //                 });
  //               },
  //               child: Text(
  //                 "גנרטור",
  //                 style: textStyle,
  //               ))),
  //       SizedBox(width: 5.0),
  //       Expanded(
  //           child: FlatButton(
  //               color: buttonColor,
  //               onPressed: () {
  //                 setState(() {
  //                   reportExpend = OneYearReport(report: report);
  //                 });
  //               },
  //               child: Text(
  //                 "חד שנתי",
  //                 style: textStyle,
  //               ))),
  //       SizedBox(width: 5.0),
  //       Expanded(
  //           child: FlatButton(
  //               color: buttonColor,
  //               onPressed: () {
  //                 setState(() {
  //                   reportExpend = FiveYearReport(report: report);
  //                 });
  //               },
  //               child: Text(
  //                 "חמש שנתי",
  //                 style: textStyle,
  //               )))
  //     ],
  //   );
  // }

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
              child: Column(children: FormAttributes().getWidgetList())),
          reportExpend,
          _saveBottun(),
        ]),
      ),
    ));
  }
}
