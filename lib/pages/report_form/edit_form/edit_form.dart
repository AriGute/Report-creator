import 'package:B.E.E/pages/report_form/edit_form/subset_viewr.dart';
import 'package:B.E.E/pages/shared/constants.dart';
import 'package:B.E.E/pages/shared/loading.dart';
import 'package:B.E.E/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final db = DatabaseService();
  List<String> subsetNames = [];
  Map<String, dynamic> form = {};
  List<Widget> widgetList = [Loading()];
  String subject = "empty";

  void addSubSet() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: TextFormField(
                decoration: textIputDecoration.copyWith(
                  hintText: 'Subject',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                ),
                onChanged: (val) {
                  subject = val;
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (subsetNames.any((element) => element == subject) ||
                        subject == "" ||
                        subject == "empty") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red[800],
                        content: Text(
                          "Pick different subject name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    } else {
                      db.addSubSet(subject, {});
                      updateWidgetList();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Create"),
                  style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                ),
              ],
            ));
  }

  void viewSubset(String uid) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SubsetViwer(uid)));
  }

  void subSetDelete(String uid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Are sure you want to delet this?"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    db.deleteSubSet(uid);
                    updateWidgetList();
                    Navigator.pop(context);
                  },
                  child: Text("Delete"),
                  style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Discard"),
                  style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                ),
              ],
            ));
  }

  Widget makeCardWidget(DocumentSnapshot dss) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 0.6, 10.0, 0),
      child: ListTile(
        leading: Icon(
          Icons.align_horizontal_left,
          color: Colors.red[500],
          size: 40.0,
        ),
        trailing: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.white,
          onPressed: () => subSetDelete(dss.id),
          child: Icon(
            Icons.delete_forever,
            color: Colors.red[500],
          ),
        ),
        title: Text(dss.data()["name"]),
        onTap: () => viewSubset(dss.id),
      ),
      color: Colors.white,
    );
  }

  Future updateWidgetList() async {
    List<Widget> tempWidgetList = [];
    subsetNames = [];
    QuerySnapshot dss = await db.getForm();
    dss.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data();
      print(data);
      tempWidgetList.add(makeCardWidget(doc));
      subsetNames.add(data["name"]);
    });
    setState(() {
      widgetList = tempWidgetList;
    });
  }

  @override
  void initState() {
    super.initState();
    updateWidgetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red[600]),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => addSubSet(),
            ),
          ],
          title: Text(
            "Edit form",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(children: widgetList));
  }
}
