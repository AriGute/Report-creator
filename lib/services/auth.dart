import 'package:firebase_auth/firebase_auth.dart';
import 'package:CreateReport/pages/models/user.dart';
import 'package:CreateReport/services/database.dart';


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
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User user = result.user;

        await DatabaseService(uid: user.uid)
            .setUserDetails(firstName, lastName, email);
        await user.sendEmailVerification();
        return _userFromFirebaseUser(user);
      }
      return null;
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
