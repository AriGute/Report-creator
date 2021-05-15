import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/models/report.dart';
import 'package:save_pdf/services/database.dart';

Future<Map> getDetails() async {
  Stream<List<Map>> details = DatabaseService().getUserDetails();
  details.forEach((item) {
    print("user details: " + item.toString());
  });
}

class ProfileBar extends StatefulWidget {
  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  @override
  Widget build(BuildContext context) {
    final details = Provider.of<List<Report>>(context);
    print(details);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(),
          Text(
            'Name',
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          FlatButton.icon(
              onPressed: () => getDetails(),
              icon: Icon(Icons.ac_unit),
              label: Text("data"))
        ]);
  }
}
