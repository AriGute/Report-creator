import 'package:flutter/material.dart';
import 'package:save_pdf/pages/shared/constants.dart';

class ProfileBar extends StatefulWidget {
  Stream<List<Map>> userDetails;
  String firstName = '';
  bool isManager = false;
  Widget managerBaget = Spacer();
  ProfileBar({this.userDetails});
  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  @override
  Widget build(BuildContext context) {
    widget.userDetails.listen((event) {
      event.forEach((element) {
        widget.firstName = element["firstName"];
        if (element["isManager"]) {
          widget.managerBaget = Icon(
            Icons.badge,
            color: Colors.white,
          );
        } else {
          widget.managerBaget = Icon(
            Icons.account_circle,
            color: Colors.white,
          );
        }
        setState(() {});
        print(element["firstName"]);
      });
    });

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(),
          Text(
            widget.firstName,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          widget.managerBaget,
          Spacer()
        ]);
  }
}
