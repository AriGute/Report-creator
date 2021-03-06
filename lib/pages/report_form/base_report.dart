import 'package:flutter/material.dart';
import 'package:CreateReport/pages/models/base_form.dart';
import 'package:CreateReport/pages/shared/constants.dart';

class BaseReport extends StatefulWidget {
  BaseForm report;
  BaseReport({this.report});
  bool castumAssigment = false;
  @override
  _BaseReportState createState() => _BaseReportState();
}

class _BaseReportState extends State<BaseReport> {
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.report.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red[500],
              onPrimary: Colors.white,
              surface: Colors.red[500],
              onSurface: Colors.red[500],
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != widget.report.selectedDate)
      setState(() {
        widget.report.selectedDate = picked;
      });
  }

  Widget _setDate() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red[500]),
        onPressed: () => _selectDate(context),
        child: RichText(
            text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.date_range_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: "  " + widget.report.selectedDate.toString().split(" ")[0],
              style: TextStyle(color: Colors.white),
            )
          ],
        )));
  }

  Widget _setWeather() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: DropdownButton<String>(
              value: widget.report.weather,
              hint: Text('?????? ??????????'),
              isExpanded: true,
              items:
                  <String>['????????', '?????????? ??????????', '??????????'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (pick) {
                print(pick);
                setState(() {
                  widget.report.weather = pick;
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Center(child: Text(':?????? ??????????')),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Divider(color: Colors.grey),
      Form(
        child: Row(children: <Widget>[
          Expanded(
            flex: 2,
            child: _setWeather(),
          ),
          SizedBox(width: 5.0),
          Expanded(flex: 1, child: _setDate()),
        ]),
      ),
      Row(children: <Widget>[
        Expanded(
            child: customTextFormField('???? ????????', (val) {
          widget.report.siteName = val;
        })),
       
      ]),
      Divider(color: Colors.grey)
    ]);
  }
}
