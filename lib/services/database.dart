import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:save_pdf/pages/models/assignment.dart';
import 'package:save_pdf/pages/models/report.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection refrence
  final CollectionReference db = FirebaseFirestore.instance.collection('Users');
  final FirebaseFirestore fb = FirebaseFirestore.instance;

  // create uniqe user docs library
  Future createUserReports() async {
    return await db.doc(uid).set({
      'date': "0",
      'name': 'ariel test',
      'anotherThing': 'some other thing'
    });
  }

  // get report doc list from snapshot
  List<Report> _reportListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Report(
          date: doc.data()['date'] ?? '',
          name: doc.data()['siteName'] ?? '',
          uid: doc.id ?? '');
    }).toList();
  }

  // get reports that belong to exist user
  Stream<List<Report>> docs() {
    final CollectionReference reportsDb = db.doc(uid).collection("Reports");
    return reportsDb.snapshots().map(_reportListFromSnapShot);
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
    final CollectionReference reportsDb = db.doc(uid).collection("Assignments");
    return reportsDb.snapshots().map(_assigmentsListFromSnapShot);
  }

  // get stream to user collection QuerySnapShot
  Stream<QuerySnapshot> getUserCollection() {
    return db.snapshots();
  }

  // get stream to current user DocumentSnapshot from users collection
  Stream<DocumentSnapshot> getCurrentUserDetails() {
    return db.doc(uid).snapshots();
  }

  // get map to current user details
  Future<Map> getUserDetails(String someUID) async {
    Stream<DocumentSnapshot> temp = await db.doc(someUID).snapshots();
    await temp.first.then((value) {
      return value.data();
    });
    return await temp.first.then((value) {
      return value.data();
    });
  }

  // get stream to specific assigment
  Future<Map> getAssignment(String assignmentId) async {
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
  }

  Future addReport(Map assigment) async {
    Map<String, dynamic> assigmentExtend = {};
    assigment.keys.forEach((key) {
      assigmentExtend[key] = assigment[key];
    });
    await db.doc(uid).collection('Reports').add(assigmentExtend);
  }

  // attatch assigment(map<string, bool> widget list indicator) to user(uid is the targeted user!, not the current user)
  Future addAssigment(String uid, Map assigment, String subject) async {
    Map<String, dynamic> assigmentExtend = {};
    assigment.keys.forEach((key) {
      assigmentExtend[key] = assigment[key];
    });

    assigmentExtend["subject"] = subject;

    DateTime now = new DateTime.now();
    String date = "${now.day}/${now.month}/${now.year}";

    assigmentExtend["date"] = date;

    await db.doc(uid).collection('Assignments').add(assigmentExtend);
  }

  // add user details to exist user
  Future setUserDetails(String firstName, String lastName, String email) async {
    return await db.doc(uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'is_manager': false,
      "email": email
    });
  }
}
