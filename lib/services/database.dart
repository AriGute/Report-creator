import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection refrence
  final CollectionReference db =
      FirebaseFirestore.instance.collection('Reports');

  // create uniqe user docs library
  Future createUserDocs() async {
    return await db.doc(uid).set({});
  }

  // add doc to exist user library
  Stream<QuerySnapshot> docs() {
    // DocumentSnapshot doc = await db.doc(uid).get();
    // if (doc.exists) {
    //   print(doc);
    // } else {
    //   createUserDocs();
    // }
    return db.snapshots();
  }
}
