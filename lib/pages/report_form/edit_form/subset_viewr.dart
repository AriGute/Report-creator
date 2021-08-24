import 'package:CreateReport/pages/shared/constants.dart';
import 'package:CreateReport/pages/shared/loading.dart';
import 'package:CreateReport/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubsetViwer extends StatefulWidget {
  final String uid;
  SubsetViwer(this.uid);
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<SubsetViwer> {
  final db = DatabaseService();
  Map<String, dynamic> subSet = {};
  List<Widget> widgetList = [Loading()];
  String subject = "empty";

  void addItem() {
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
                    Map<String, dynamic> content = subSet['content'];
                    if (content.containsKey(subject) ||
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
                      content[subject] = " ";
                      db.updateFolderContent(widget.uid, subSet);
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

  void deleteSubSetItem(String key) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Are sure you want to delet this?"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> content = subSet['content'];
                    content.remove(key);
                    subSet['content'] = content;

                    db.updateFolderContent(widget.uid, subSet);
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

  Widget makeCardWidget(String subject) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 0.6, 10.0, 0),
      child: ListTile(
        trailing: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.white,
          onPressed: () => deleteSubSetItem(subject),
          child: Icon(
            Icons.delete_forever,
            color: Colors.red[500],
          ),
        ),
        title: Text(subject),
        onTap: () {},
      ),
      color: Colors.white,
    );
  }

  Future updateWidgetList() async {
    List<Widget> tempWidgetList = [];
    DocumentSnapshot dss = await db.getSubSet(widget.uid);
    Map<String, dynamic> content = dss.data()['content'];
    subSet = dss.data();
    print(subSet);
    content.forEach((key, value) {
      tempWidgetList.add(makeCardWidget(key));
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
              onPressed: addItem,
            ),
          ],
          title: Text(
            "Subset viewer",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(children: widgetList));
  }
}
