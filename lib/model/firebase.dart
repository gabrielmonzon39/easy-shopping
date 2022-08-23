// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

const String NONE = "none";
const String USER = "user";
const String STORE_MANAGER = "store_manager";
const String PROJECT_MANAGER = "project_manager";
const String DELIVERY_MAN = "delivery_man";
const String PROVIDER = "provider";

String currentRoll = "none";
String? uid;

class FirebaseFS {
  static Future<bool> isAssociatedUser(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return userDetail.get('role') != "none";
  }

  static void changeRole(String uid, String role) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'role': role});
  }

  static Future<String> getRole() async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      if (userDetail.get('role') == null) {
        changeRole(uid!, NONE);
        return NONE;
      }
    } catch (e) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'role': NONE});
      return NONE;
    }
    return userDetail.get('role');
  }

  static Future<bool> addToken(String token) async {
    DocumentSnapshot tokenDetail =
        await FirebaseFirestore.instance.collection('tokens').doc(token).get();

    int remaining = 0;

    // check if the token exists.
    try {
      remaining = tokenDetail.get('remaining');
    } catch (e) {
      return false;
    }

    // check if is it available
    if (remaining == 0) {
      return false;
    }
    remaining--;

    // reduce the token remaining uses
    FirebaseFirestore.instance
        .collection('tokens')
        .doc(token)
        .update({'remaining': remaining});

    // change roll to USER
    String role = tokenDetail.get('role');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'role': role});
    currentRoll = role;

    // associate user to the house provided by the token
    String homeId = tokenDetail.get("home_id");
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'home_id': homeId});

    return true;
  }
}
