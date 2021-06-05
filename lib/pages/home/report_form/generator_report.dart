import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/base_form.dart';

// not used at the moment
class GeneratorReport extends StatefulWidget {
  List<Widget> widgetList = [];
  BaseForm report;
  GeneratorReport({this.report}) {
    widgetList = [Text('גנרטור')];
  }
  @override
  _GeneratorReportState createState() => _GeneratorReportState();
}

class _GeneratorReportState extends State<GeneratorReport> {
  @override
  Widget build(BuildContext context) {
    return Column(children: widget.widgetList);
  }
}
