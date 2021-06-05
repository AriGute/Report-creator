import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/models/assignment_tile.dart';
import 'package:save_pdf/pages/models/assignment.dart';
import 'package:save_pdf/pages/shared/loading.dart';

class AssigmentList extends StatefulWidget {
  Widget assigments = Loading();

  @override
  _AssigmentListState createState() => _AssigmentListState();
}

class _AssigmentListState extends State<AssigmentList> {
  Future getWidget() async {
    final assigmentList = Provider.of<List<Assignment>>(context);
    print(assigmentList);
    if (assigmentList.length > 0) {
      widget.assigments = ListView.builder(
          itemCount: assigmentList.length,
          itemBuilder: (context, index) {
            return AssigmentTile(assigment: assigmentList[index]);
          });
    } else {
      widget.assigments = Text("No reports found.");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getWidget();
    return widget.assigments;
  }
}
