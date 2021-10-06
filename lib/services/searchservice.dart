import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser?.uid)
        .collection('vaccines')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}
