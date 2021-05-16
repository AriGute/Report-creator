import 'package:flutter/material.dart';

Widget sideWindows() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.red[500],
    ),
    body: ListView(
      children: [Container(child: Text("side windows:"))],
    ),
  );
}
