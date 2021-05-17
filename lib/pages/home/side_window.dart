import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/models/report.dart';

class SideWindows extends StatelessWidget {
  Stream<List<Map>> profile;
  SideWindows({this.profile});

  @override
  Widget build(BuildContext context) {
    List<Report> reportList = Provider.of<List<Report>>(context);

    ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.red[500],
      primary: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
      ),
      body: ListView(
        children: [
          Container(
              child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: buttonStyle,
                  onPressed: () {
                    print(profile);
                  },
                  child: Text("test"),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
