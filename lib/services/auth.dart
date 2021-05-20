import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:save_pdf/pages/authenticate/authenticate.dart';
import 'package:save_pdf/pages/models/user.dart';
import 'package:save_pdf/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getUid() {
    return _auth.currentUser.uid;
  }

  // create user obj based on Firebase User
  MyUser _userFromFirebaseUser(User user) {
    // print("user:  $user");
    return user != null
        ? MyUser(
            uid: user.uid,
          )
        : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // print("<[auth => signInWithEmailAndPassword, result: " +
      //     result.user.toString() +
      //     "]>");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      await DatabaseService(uid: user.uid)
          .setUserDetails(firstName, lastName, email);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
