import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/models/assignment_tile.dart';
import 'package:save_pdf/pages/models/assignment.dart';
import 'package:save_pdf/pages/shared/loading.dart';

class AssigmentList extends StatefulWidget {
  @override
  _AssigmentListState createState() => _AssigmentListState();
}

class _AssigmentListState extends State<AssigmentList> {
  Widget getWidget(List assigmentList) {
    Widget assigments = Loading();
    if (assigmentList.length > 0) {
      assigments = ListView.builder(
          itemCount: assigmentList.length,
          itemBuilder: (context, index) {
            return AssigmentTile(assigment: assigmentList[index]);
          });
      return assigments;
    } else {
      return Text("No reports found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final assigmentList = Provider.of<List<Assignment>>(context);
    return assigmentList == null ? Loading() : getWidget(assigmentList);
  }
}
