import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/base_form.dart';

class FiveYearReport extends StatefulWidget {
  BaseForm report;
  FiveYearReport({this.report});
  @override
  _FiveYearReportState createState() => _FiveYearReportState();
}

class _FiveYearReportState extends State<FiveYearReport> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('חמש שנתי')]);
  }
}
