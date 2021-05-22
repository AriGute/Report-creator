import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/base_form.dart';

// not used at the moment
class OneYearReport extends StatefulWidget {
  BaseForm report;
  OneYearReport({this.report});
  @override
  _OneYearReportState createState() => _OneYearReportState();
}

class _OneYearReportState extends State<OneYearReport> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('חד שנתי')]);
  }
}
