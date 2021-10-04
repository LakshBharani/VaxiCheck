// ignore_for_file: avoid_print, unused_local_variable

import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaxicheck/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  String currentDate =
      DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

// creating instance of user
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

// register with email and password
  Future resgisterWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }

    var firebaseUser = FirebaseAuth.instance.currentUser;

    firestoreInstance.collection("users").doc(firebaseUser?.uid).set({
      //   "vaccName": {
      //     "date": currentDate,
      //     "doses": 0,
      //     "searchKey": "null",
      //   }
      // }).then((_) {
      //   print("success!");
    });
  }

// sign in with email and pwd
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
