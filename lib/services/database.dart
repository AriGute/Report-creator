import 'dart:io';

import 'package:B.E.E/services/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:B.E.E/pages/models/assignment.dart';
import 'package:B.E.E/pages/models/report.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String uid;
  final String reportFormUid = "EMFSTZ9oxm3rHGYD5rjd";
  DatabaseService({this.uid});
  final CollectionReference db = FirebaseFirestore.instance.collection('Users');
  FirebaseStorage storage = FirebaseStorage.instanceFor();
  final FirebaseFirestore fb = FirebaseFirestore.instance;

  // create uniqe user docs library
  Future createUserReports() async {
    try {
      return await db.doc(uid).set({
        'date': "0",
        'name': 'ariel test',
        'anotherThing': 'some other thing'
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  // get report doc list from snapshot
  List<Report> _reportListFromSnapShot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Report(
          uid, // owner of report
          doc.id ?? '', // report uid
          date: doc.data()['date'] ?? '',
          name: doc.data()['siteName'] ?? '',
        );
      }).toList();
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get report(with report uid) of some worker(with worker uid)
  Future<DocumentSnapshot> getReport(String ownerUid, String reportUid) {
    try {
      Future<DocumentSnapshot> report =
          db.doc(ownerUid).collection("Reports").doc(reportUid).get();

      // final DocumentReference reportsDb =
      //     db.doc(ownerUid).collection("Reports").doc(reportUid);
      return report.then((value) {
        return value;
      });
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get reports that belong to exist user
  Stream<List<Report>> docs() {
    try {
      final CollectionReference reportsDb = db.doc(uid).collection("Reports");
      return reportsDb.snapshots().map(_reportListFromSnapShot);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get snapshot of assignments.
  List<Assignment> _assigmentsListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Assignment(
          subject: doc.data()["subject"] ?? 'No subject',
          date: doc.data()["date"] ?? '0/0/0',
          uid: doc.id);
    }).toList();
  }

  // get assignments that belong to exist user
  Stream<List<Assignment>> assignments() {
    try {
      final CollectionReference reportsDb =
          db.doc(uid).collection("Assignments");
      return reportsDb.snapshots().map(_assigmentsListFromSnapShot);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get stream to current user DocumentSnapshot from users collection
  Stream<DocumentSnapshot> getCurrentUserDetails() {
    try {
      return db.doc(uid).snapshots();
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get map to current user details
  Future<Map> getUserDetails(String someUID) async {
    try {
      Stream<DocumentSnapshot> temp = await db.doc(someUID).snapshots();
      await temp.first.then((value) {
        return value.data();
      });
      return await temp.first.then((value) {
        return value.data();
      });
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get stream to specific assigment
  Future<Map> getAssignment(String assignmentId) async {
    try {
      print("uid: ${uid}, assigemnt uid: ${assignmentId}");
      Stream<DocumentSnapshot> temp = await db
          .doc(uid)
          .collection("Assignments")
          .doc(assignmentId)
          .snapshots();
      await temp.first.then((value) {
        print("1 ${value.exists}");
        return value.data();
      });
      return await temp.first.then((value) {
        print("2 ${value.data()}");
        return value.data();
      });
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // Add report to the current user
  Future<String> addReport(Map assigment) async {
    try {
      Map<String, dynamic> assigmentExtend = {};
      assigment.keys.forEach((key) {
        assigmentExtend[key] = assigment[key];
      });
      return await db
          .doc(uid)
          .collection('Reports')
          .add(assigmentExtend)
          .then((value) {
        return value.id;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  // attatch assigment(map<string, bool> widget list indicator) to user(uid is the targeted user!, not the current user)
  Future addAssigmentOld(String uid, Map assigment, String subject) async {
    try {
      Map<String, dynamic> assigmentExtend = {};
      assigment.keys.forEach((key) {
        assigmentExtend[key] = assigment[key];
      });

      assigmentExtend["subject"] = subject;

      DateTime now = new DateTime.now();
      String date = "${now.day}/${now.month}/${now.year}";

      assigmentExtend["date"] = date;

      await db.doc(uid).collection('Assignments').add(assigmentExtend);
    } on Exception catch (e) {
      print(e);
    }
  }

  // add user details to exist user
  Future setUserDetails(String firstName, String lastName, String email) async {
    try {
      return await db.doc(uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'is_manager': false,
        "email": email
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  //////////////////  new form edit /////////////////

  // Image _photosFromSnapShot(QuerySnapshot snapshot) {
  //   try {
  //     return snapshot.docs.map((doc) {
  //       return Image.network(await storage.ref().child("uploads/$"));
  //     }).toList();
  //   } on Exception catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future deletePhotos(String reportUid) async {
    try {
      // Reference ref = storage.ref("uploads/$uid");
      final String destenation = "uploads/$reportUid";
      final ref = storage.ref(destenation);
      final result = await ref.listAll();
      result.items.forEach((imgRef) {
        imgRef.delete();
      });
      print("ref path: " + ref.fullPath);
      ref.delete();
    } on Exception catch (e) {
      print("Exeption while trying to delete photos: " + e.toString());
    }
  }
  // void deletePhotos(List<String> urls) {
  //   urls.forEach((url) {
  //     storage.refFromURL(url).delete();
  //   });
  // }

  Future<List<String>> _getFownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  }

  Future<List<String>> getPhotos(String reportUid) async {
    try {
      final String destenation = "uploads/$reportUid";
      final ref = storage.ref(destenation);
      final result = await ref.listAll();
      final urls = await _getFownloadLinks(result.items);
      return urls;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // upload img to firebase and return its path.
  Future<String> uploadImag(File file, String reportUid, String name) async {
    final String destenation = "uploads/$reportUid/$name";
    try {
      return await FireBaseApi.uploadFile(destenation, file).then((tss) {
        return tss.ref.fullPath;
      });
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> downloadImg(String path) async {
    String fileName = path.split("/").last;
    final String destenation = "uploads/$fileName";

    return FireBaseApi.downloadFileUrl(destenation);
  }

  // add folder to the report form
  Future addSubSet(String folderName, Map<String, String> folderContent) async {
    await FirebaseFirestore.instance
        .collection('ReportForm')
        .add({'name': folderName, 'content': folderContent});
  }

  // add folder to the report form
  Future addSubSetItem(String uid, Map<String, String> content) async {
    await FirebaseFirestore.instance
        .collection('ReportForm')
        .doc(uid)
        .update(content);
  }

  // add folder to the report form
  Future deleteSubSet(String folderDocId) async {
    await FirebaseFirestore.instance
        .collection('ReportForm')
        .doc(folderDocId)
        .delete();
  }

  // get specific folder by folder doc id
  Future<DocumentSnapshot> getSubSet(String folderUid) async {
    final DocumentSnapshot rf = await FirebaseFirestore.instance
        .collection('ReportForm')
        .doc(folderUid)
        .get();
    return rf;
  }

  // get a querysnapshot of form
  Future<QuerySnapshot> getForm() async {
    final QuerySnapshot qss =
        await FirebaseFirestore.instance.collection('ReportForm').get();
    return qss;
  }

  // update report form
  Future updateFolderContent(String uid, Map<String, dynamic> content) async {
    await FirebaseFirestore.instance
        .collection('ReportForm')
        .doc(uid)
        .set(content);
  }

  //////////////////  new form edit /////////////////

  // set report form attributes
  Future setReportForm(List reportForm) async {
    try {
      Map<String, String> form = {};
      reportForm.forEach((subject) {
        form[subject] = subject;
      });
      return await FirebaseFirestore.instance
          .collection('ReportForm')
          .doc(reportFormUid)
          .set(form);
    } on Exception catch (e) {
      print(e);
    }
  }

  // get report form attributes
  Future<DocumentSnapshot> getReportForm() async {
    try {
      final DocumentSnapshot rf = await FirebaseFirestore.instance
          .collection('ReportForm')
          .doc(reportFormUid)
          .get();
      if (rf.exists) {
        return rf;
      } else {
        print("Collection 'ReportForm' not exits, create new one.");
        await setReportForm(["new"]);
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  // get future QuerySnapshot of users(used to get user details)
  Future<QuerySnapshot> getUsers() async {
    try {
      final QuerySnapshot reportForm = await db.get();
      return reportForm;
    } on Exception catch (e) {
      print(e);
    }
  }

  // delet assigment for user from the db
  Future deletAssignments(String workerUid, String reportUid) async {
    try {
      print("Delet report: " + reportUid);
      final CollectionReference reportsDb =
          db.doc(workerUid).collection("Assignments");
      await reportsDb.doc(reportUid).delete();
      print("Finish deleting.");
    } on Exception catch (e) {
      print(e);
    }
  }

  // delet report for user from the db
  Future deletReport(String workerUid, String reportUid) async {
    try {
      print("Delet report: " + reportUid);
      final CollectionReference reportsDb =
          db.doc(workerUid).collection("Reports");
      await reportsDb.doc(reportUid).delete();
      print("Finish deleting.");
    } on Exception catch (e) {
      print(e);
    }
  }
}
