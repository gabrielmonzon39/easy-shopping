import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFS {
  static Future<bool> isAssociatedUser(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDetail.get('role') != null;
  }

  static void addUser(String uid, String role) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({'role': role});
  }
}
