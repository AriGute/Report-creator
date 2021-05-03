import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:save_pdf/pages/models/report.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection refrence
  final CollectionReference db = FirebaseFirestore.instance.collection('Users');

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
    print("<[database.dart => _reportListFromSnapShot]>");
    // print("UID: $uid");
    return snapshot.docs.map((doc) {
      return Report(
          date: doc.data()['date'] ?? '',
          name: doc.data()['name'] ?? '',
          anotherThing: doc.data()['anotherThing'] ?? '');
    }).toList();
  }

  // get reports that belong to exist user
  Stream<List<Report>> docs() {
    print("<[database.dart => docs]>");
    print("docs UID: $uid");
    final CollectionReference reportsDb = db.doc(uid).collection("Reports");
    print(reportsDb);
    return reportsDb.snapshots().map(_reportListFromSnapShot);
  }

  // add reports to exist user
  Future addReport() async {
    return await db.doc(uid).collection('Reports').add({
      'date': "0",
      'name': 'ariel test',
      'anotherThing': 'some other thing'
    });
  }
}
