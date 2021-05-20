import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          name: doc.data()['name'] ?? '',
          anotherThing: doc.data()['anotherThing'] ?? '');
    }).toList();
  }

  // get reports that belong to exist user
  Stream<List<Report>> docs() {
    final CollectionReference reportsDb = db.doc(uid).collection("Reports");
    return reportsDb.snapshots().map(_reportListFromSnapShot);
  }

  // get stream to user collection QuerySnapShot
  Stream<QuerySnapshot> getUserCollection() {
    return db.snapshots();
  }

  // get stream to current user DocumentSnapshot from users collection
  Stream<DocumentSnapshot> getCurrentUserDetails() {
    return db.doc(uid).snapshots();
  }

  // get stream to current user DocumentSnapshot from users collection
  Future<Map> getUserDetails(String someUID) async {
    // print("<[database.dart => getUserDetails]>");
    Stream<DocumentSnapshot> temp = await db.doc(someUID).snapshots();
    // print("temp2");
    // Map stam = {};

    await temp.first.then((value) {
      return value.data();
    });
    return await temp.first.then((value) {
      return value.data();
    });
  }

  // add reports to exist user
  Future addReport() async {
    return await db.doc(uid).collection('Reports').add({
      'date': "0",
      'name': 'test',
      'anotherThing': 'some other thing',
    });
  }

  // add user details to exist user
  Future setUserDetails(String firstName, String lastName, String email) async {
    return await db.doc(uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'is_manager': false,
      "email": email
    });
    // return await db.doc(uid).collection('userDetails').add(
    //     {'first_name': firstName, 'last_name': lastName, 'is_manager': false});
  }

  dynamic someFunc() {
    dynamic users = db.doc();
  }
}
