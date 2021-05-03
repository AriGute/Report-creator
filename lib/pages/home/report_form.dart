import 'package:flutter/material.dart';
import 'package:save_pdf/pages/shared/constants.dart';

class ReportForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text(
          "Create Report:",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(children: [
          Form(
            child: TextFormField(
              decoration: textIputDecoration.copyWith(
                  hintText: "Somthing to test with"),
            ),
          ),
          RaisedButton(
              color: Colors.red[500],
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                //TODO: async function for uploading the report.
                print("Save report.");
                Navigator.pop(context);
              })
        ]),
      ),
    );
  }
}
