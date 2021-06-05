import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/shared/loading.dart';

class ProfileBar extends StatefulWidget {
  String firstName = '';
  bool isManager = false;
  Widget managerBaget = Spacer();
  ProfileBar();
  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  // TODO: move this to database services
  // Future getWidget() async {
  //   if (userDetails != null) {
  //     widget.firstName =
  //         userDetails["first_name"] + " " + userDetails["last_name"];
  //     if (userDetails["is_manager"]) {
  //       widget.managerBaget = Icon(
  //         Icons.badge,
  //         color: Colors.white,
  //       );
  //     } else {
  //       widget.managerBaget = Icon(
  //         Icons.account_circle,
  //         color: Colors.white,
  //       );
  //     }
  //   }
  //   setState(() {});
  // }

  Widget getBadge(bool isManager) {
    if (isManager) {
      return widget.managerBaget = Icon(
        Icons.badge,
        color: Colors.white,
      );
    } else {
      return widget.managerBaget = Icon(
        Icons.account_circle,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot userDetails = Provider.of<DocumentSnapshot>(context);

    // getWidget();

    return (userDetails == null)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Spacer(),
                Text(
                  "Loading user info...",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer()
              ])
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Spacer(),
                Text(
                  userDetails.data()["first_name"] +
                      " " +
                      userDetails.data()["last_name"],
                  //widget.firstName,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                getBadge(userDetails.data()["is_manager"]),
                Spacer()
              ]);
  }
}
