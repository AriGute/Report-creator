import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:CreateReport/pages/report_form/base_report.dart';
import 'package:CreateReport/pages/models/assignment.dart';
import 'package:CreateReport/pages/models/base_form.dart';
import 'package:CreateReport/pages/shared/loading.dart';
import 'package:CreateReport/services/auth.dart';
import 'package:CreateReport/services/database.dart';
import 'package:CreateReport/pages/shared/constants.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ReportForm extends StatefulWidget {
  final Assignment assigment;
  ReportForm({this.assigment});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final AuthService _auth = AuthService();
  DatabaseService db;
  List<XFile> imgs = [];
  List<Widget> imgPreview = [];
  BaseForm baseReport;
  List<Widget> widgetList = [Loading()];

  // for each subset item, if item is true then show its content
  Map<String, bool> subSetCheck = {};
  // subsets content
  Map<String, dynamic> subsetContent = {};

  Widget reportExpend;
  Map<String, dynamic> report = {};
  List<String> reportPhotos = [];

  bool readyToBeSave = true;

  Future _uploadImgs(String reportUid) async {
    if (imgs.isNotEmpty) {
      int numOfImgs = imgs.length;
      int countUploads = 0;

      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: numOfImgs, msg: 'Upload Photos..');

      await Future.forEach(imgs, (img) async {
        File file = File(img.path);
        String name = img.path.split("/").last;
        reportPhotos
            .add(await db.uploadImag(file, reportUid, name).then((value) {
          countUploads += 1;
          print("uploaded img: " +
              countUploads.toString() +
              "/" +
              numOfImgs.toString());
        }));
        pd.update(value: countUploads);
      });
      if (countUploads == numOfImgs) {
        pd.close();
      }
    }
  }

  void _saveFunction() {
    if (widget.assigment != null) {
      db.deletAssignments(_auth.getUid(), widget.assigment.uid);
    }
    initBaseReport();
    print("report : " + report.toString());

    db.addReport(report).then((reportUid) async {
      await _uploadImgs(reportUid).then((value) => Navigator.pop(context));
    });

    // Navigator.pop(context);
  }

  void _saveReport() {
    print("start saving");
    readyToBeSave = true;
    report.forEach((key, val) {
      print("checking1");
      print(val);
      if (val == "") {
        readyToBeSave = false;
      }
    });
    print("check if ready to be saved");

    if (readyToBeSave) {
      _saveFunction();
    } else {
      print("cant save rigth now");
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Some field are empty.\nContinue saving process?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _saveFunction();
                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                    style: ElevatedButton.styleFrom(primary: Colors.red[500]),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                      style: ElevatedButton.styleFrom(primary: Colors.red[500]))
                ],
              ),
          barrierDismissible: false);
    }
  }

  Widget _saveBottun() {
    return Container(
      alignment: Alignment.topRight,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red[500],
            primary: Colors.white,
          ),
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            try {
              _saveReport();
            } on Exception catch (e) {
              // should skip save phase if throw exeption.
              SnackBar(
                backgroundColor: Colors.red[800],
                content: Text(
                  "Error, could not delet the assignment before creating new report.",
                  style: TextStyle(color: Colors.white),
                ),
              );
              print(e);
            }
          }),
    );
  }

  // Convert DateTime to string
  String dateFormat(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  void initBaseReport() {
    report["date"] = dateFormat(baseReport.selectedDate);
    report["siteName"] = baseReport.siteName;
    report["logo"] = baseReport.logo;
    report["weather"] = baseReport.weather;
  }

  Widget makeCardWidget(String subject) {
    return Column(
      children: [
        Container(
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  subject,
                  style: TextStyle(color: Colors.black),
                ))),
        TextFormField(
          decoration: textIputDecoration.copyWith(hintText: "Empty."),
          initialValue: report[subject],
          maxLines: 3,
          onChanged: (val) {
            report[subject] = val;
            if (val == "") {
              report.remove(subject);
            }
            print(report);
          },
        )
      ],
    );
  }

  void _pickFromLocal() async {
    imgs = [];
    imgPreview = [];
    imgs = await ImagePicker().pickMultiImage();
    if (imgs != null) {
      print("image info: ");
      print(imgs.length);

      setState(() {
        imgs.forEach((img) {
          Image currentImg = Image.file(
            File(img.path),
            fit: BoxFit.scaleDown,
            scale: 5,
            filterQuality: FilterQuality.low,
          );
          imgPreview.add(Divider(
            color: Colors.grey,
          ));
          imgPreview.add(currentImg);
        });
      });
    } else {
      print("image is null.");
    }
  }

  // build report widget list based on data from db.
  Future setReport() async {
    List<Widget> tempWidgetList = [];
    initBaseReport();
    Map<String, bool> tempSubSetsChecker = {};
    Map<String, dynamic> tempSubSetsContent = {};

    QuerySnapshot qss = await db.getForm();
    qss.docs.forEach((item) {
      Map<String, dynamic> subset = item.data();
      Map<String, dynamic> content = subset["content"];
      tempSubSetsChecker[subset["name"]] = false;
      tempSubSetsContent[subset["name"]] = content;

      List<Widget> contentWidgetList = [];
      content.forEach((key, value) {
        contentWidgetList.add(makeCardWidget(key));
      });

      tempWidgetList.add(ExpansionTile(
        title: Row(children: [
          Icon(Icons.align_horizontal_left),
          Text(subset["name"])
        ]),
        maintainState: true,
        onExpansionChanged: (val) => tempSubSetsChecker[subset["name"]] = val,
        children: contentWidgetList,
      ));
      tempWidgetList.add(Divider(color: Colors.grey));
    });

    setState(() {
      subSetCheck = tempSubSetsChecker;
      subsetContent = tempSubSetsContent;
      widgetList = tempWidgetList;
    });
  }

  @override
  void initState() {
    super.initState();
    db = DatabaseService(uid: _auth.getUid());
    baseReport = new BaseForm();
    reportExpend = Text("");
    setReport();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text(
          "Create Report:",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(children: [
          BaseReport(report: baseReport),
          Container(
              alignment: Alignment.topRight,
              child: Column(children: widgetList)),
          reportExpend,
          ExpansionTile(
              title: Row(children: [Icon(Icons.art_track), Text("Photos")]),
              maintainState: true,
              children: imgPreview),
          ElevatedButton(
            onPressed: () => _pickFromLocal(),
            child: Icon(Icons.add_photo_alternate),
            style: ElevatedButton.styleFrom(primary: Colors.red[500]),
          ),
          _saveBottun(),
        ]),
      ),
    ));
  }
}
