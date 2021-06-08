import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_pdf/pages/models/assignment.dart';
import 'package:save_pdf/pages/models/report.dart';

class DatabaseService {
  final String uid;
  final String reportFormUid = "EMFSTZ9oxm3rHGYD5rjd";
  DatabaseService({this.uid});
  //collection refrence
  final CollectionReference db = FirebaseFirestore.instance.collection('Users');
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
  DocumentReference getReport(String workerUid, String reportUid) {
    try {
      final DocumentReference reportsDb =
          db.doc(workerUid).collection("Reports").doc(reportUid);
      return reportsDb;
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

  // get report doc list from snapshot
  List<Assignment> _assigmentsListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Assignment(
          subject: doc.data()["subject"] ?? 'No subject',
          date: doc.data()["date"] ?? '0/0/0',
          uid: doc.id);
    }).toList();
  }

  // get reports that belong to exist user
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
  Future addReport(Map assigment) async {
    try {
      Map<String, dynamic> assigmentExtend = {};
      assigment.keys.forEach((key) {
        assigmentExtend[key] = assigment[key];
      });
      await db.doc(uid).collection('Reports').add(assigmentExtend);
    } on Exception catch (e) {
      print(e);
    }
  }

  // attatch assigment(map<string, bool> widget list indicator) to user(uid is the targeted user!, not the current user)
  Future addAssigment(String uid, Map assigment, String subject) async {
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
      // final CollectionReference reportForm =
      //     FirebaseFirestore.instance.collection('ReportForm');
      // QuerySnapshot rfdss = await reportForm.limit(1).get();
      // if (rfdss.size == 0) {
      //   print("Collection 'ReportForm' not exits, create new one.");
      //   await setReportForm(["new"]);
      // }
      // return rfdss.docs.first;
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
}
