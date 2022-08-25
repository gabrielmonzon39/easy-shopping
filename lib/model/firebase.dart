// ignore_for_file: constant_identifier_names, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';

const String NONE = "none";
const String USER = "user";
const String STORE_MANAGER = "store_manager";
const String PROJECT_MANAGER = "project_manager";
const String DELIVERY_MAN = "delivery_man";
const String PROVIDER = "provider";
const String SUPER_ADMIN = "admin";

String currentRoll = "none";
String? uid;
String? homeId;

class FirebaseFS {
  static Future<bool> isAssociatedUser(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return userDetail.get('role') != "none";
  }

  static Future<String> getHomeOf(String uid) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    DocumentSnapshot? userDetail;
    String? homeId;
    try {
      userDetail = await instance.collection('users').doc(uid).get();
      homeId = userDetail.get('home_id');
      return homeId!;
    } catch (e) {}
    return "0";
  }

  static Future<String> getStoreId(String uid) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    DocumentSnapshot? userDetail;
    String? storeId;
    try {
      userDetail = await instance.collection('users').doc(uid).get();
      storeId = userDetail.get('store_id');
      return storeId!;
    } catch (e) {}
    return "0";
  }

  static Future<DocumentSnapshot?> getStoreDetails(String storeId) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    try {
      return await instance.collection('stores').doc(storeId).get();
    } catch (e) {}
    return null;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUsers() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    return instance.collection('users').get();
  }

  static void changeRole(String uid, String role) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'role': role});
  }

  static Future<String> saveHomeId() async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      homeId = userDetail.get('home_id');
    } catch (e) {
      return NONE;
    }
    return homeId!;
  }

  static Future<String> getName(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('name');
    } catch (e) {}
    return NONE;
  }

  static Future<String> getEmail(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('email');
    } catch (e) {}
    return NONE;
  }

  static Future<String> getPhoto(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('photo');
    } catch (e) {}
    return NONE;
  }

  static Future<String> getcreationTime(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('creationTime');
    } catch (e) {}
    return NONE;
  }

  static Future<String> getlastSignInTime(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('lastSignInTime');
    } catch (e) {}
    return NONE;
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
          .set({'role': NONE, 'name': NONE, 'email': NONE});
      return NONE;
    }
    return userDetail.get('role');
  }

  static Future<void> addCredentials(String uid, String name, String email,
      String photoUrl, String creationTime, String lastSignInTime) async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'photo': photoUrl,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime
    });
  }

  static Future<void> addProduct(String storeId, String name,
      String description, String price, String quantity, String image) async {
    FirebaseFirestore.instance.collection('products').add({
      'store_id': storeId,
      'name': name,
      'description': description,
      'price': int.parse(price),
      'quantity': int.parse(quantity),
      'image': image
    });
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

    // change roll
    String role = tokenDetail.get('role');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'role': role});

    currentRoll = role;

    switch (currentRoll) {
      case USER:
        // associate user to the house provided by the token
        String homeId = tokenDetail.get("home_id");
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'home_id': homeId});
        break;
      case STORE_MANAGER:
        // associate user to the store provided by the token
        String storeId = tokenDetail.get("store_id");
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'store_id': storeId});
        break;
      case PROJECT_MANAGER:

      case DELIVERY_MAN:

      case PROVIDER:

      case SUPER_ADMIN:

      case NONE:
    }

    return true;
  }
}
