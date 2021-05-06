import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/base_form.dart';

class GeneratorReport extends StatefulWidget {
  BaseForm report;
  GeneratorReport({this.report});
  @override
  _GeneratorReportState createState() => _GeneratorReportState();
}

class _GeneratorReportState extends State<GeneratorReport> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('גנרטור')]);
  }
}
