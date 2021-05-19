import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/shared/constants.dart';

class ProfileBar extends StatefulWidget {
  String firstName = '';
  bool isManager = false;
  Widget managerBaget = Spacer();
  ProfileBar();
  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  Future getWidget() async {
    final Map userDetails = Provider.of<Map>(context);
    widget.firstName = userDetails["firstName"] + " " + userDetails["lastName"];
    if (userDetails["isManager"]) {
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
  }

  @override
  Widget build(BuildContext context) {
    getWidget();

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
