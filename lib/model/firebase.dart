// ignore_for_file: constant_identifier_names, empty_catches, avoid_print
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// person role
const String NONE = "none";
const String USER = "user";
const String STORE_MANAGER = "store_manager";
const String PROJECT_MANAGER = "project_manager";
const String DELIVERY_MAN = "delivery_man";
const String PROVIDER = "provider";
const String SUPER_ADMIN = "admin";

// product state
const String PREPARING = "preparing";
const String ONTHEWAY = "on the way";
const String SERVED = "served";

// type of products
const typesFB = [
  "clothes",
  "footwear",
  "entertainment",
  "toys",
  "food",
  "drink",
  "Alcohol drink",
  "accessory",
  "cleaning",
  "medicine",
  "pets",
  "school supplies",
  "techonology",
  "other",
];
const types = [
  "Ropa",
  "Calzado",
  "Entretenimiento",
  "Juguetes",
  "Comida",
  "Bebida",
  "Bebida Alcohólica",
  "Accesorio",
  "Limpieza",
  "Medicina",
  "Mascotas",
  "Útiles escolares",
  "Tecnología",
  "Otro",
];

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
    } catch (e) {
      print(e.toString());
    }
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
    } catch (e) {
      print(e.toString());
    }
    return "0";
  }

  static Future<int> getColorStore(String id) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    DocumentSnapshot? storeDetail;
    int? color;
    try {
      storeDetail = await instance.collection('stores').doc(id).get();
      color = storeDetail.get('color');
      return color!;
    } catch (e) {
      print(e.toString());
    }
    return 0xFF2697FF;
  }

  static Future<String> getProjectId(String uid) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    DocumentSnapshot? documentDetails;
    String? homeId;
    String? projectId;
    try {
      documentDetails = await instance.collection('users').doc(uid).get();
      homeId = documentDetails.get('home_id');
      documentDetails = await instance.collection('homes').doc(homeId).get();
      projectId = documentDetails.get('project_id');
      return projectId!;
    } catch (e) {
      print(e.toString());
    }
    return "0";
  }

  static Future<DocumentSnapshot?> getStoreDetails(String storeId) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    try {
      return await instance.collection('stores').doc(storeId).get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<DocumentSnapshot?> getOrderDetails(String orderId) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    try {
      return await instance.collection('orders').doc(orderId).get();
    } catch (e) {
      print(e.toString());
    }
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
      print(e.toString());
      return NONE;
    }
    return homeId!;
  }

  static Future<String> getName(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('name');
    } catch (e) {
      print(e.toString());
    }
    return NONE;
  }

  static Future<String> getEmail(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('email');
    } catch (e) {
      print(e.toString());
    }
    return NONE;
  }

  static Future<String> getPhoto(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('photo');
    } catch (e) {
      print(e.toString());
    }
    return NONE;
  }

  static Future<String> getcreationTime(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('creationTime');
    } catch (e) {
      print(e.toString());
    }
    return NONE;
  }

  static Future<String> getlastSignInTime(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      return userDetail.get('lastSignInTime');
    } catch (e) {
      print(e.toString());
    }
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
      print(e.toString());
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

  static Future<void> addProduct(
      String storeId,
      String name,
      String description,
      String price,
      String quantity,
      String image,
      String type) async {
    String fireBaseType = typesFB[types.indexOf(type)];
    FirebaseFirestore.instance.collection('products').add({
      'store_id': storeId,
      'name': name,
      'description': description,
      'price': int.parse(price),
      'quantity': int.parse(quantity),
      'image': image,
      'type': fireBaseType,
    });
  }

  static CollectionReference getStores() {
    return FirebaseFirestore.instance.collection('stores');
  }

  static Future<bool> isProductFromStore(
      String productId, String storeId) async {
    DocumentSnapshot productDetail = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    String realStoreId = productDetail.get('store_id');
    return realStoreId == storeId;
  }

  static Future<void> makeSales(List<Map<dynamic, dynamic>> products,
      String storeId, int orderId, int deliveryProcessId) async {
    if (products.isEmpty) return;
    String now = DateFormat("hh:mm dd-MM-yyyy").format(DateTime.now());
    try {
      ////////////////  MAKE THE SALE
      FirebaseFirestore.instance.collection('sales').add({
        'delivery_processId': deliveryProcessId.toString(),
        'date': now,
        'products': products,
        'user_id': uid,
        'store_id': storeId,
        'order_id': orderId.toString(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  ////////////////  PREPARE THE SALE(S)
  static Future<void> prepareSales(List<Map<dynamic, dynamic>> products,
      int orderId, int deliveryProcessId) async {
    QuerySnapshot stores = await getStores().get();
    Map<String, List<Map<dynamic, dynamic>>> storesAndProducts = {};
    for (int i = 0; i < stores.size; i++) {
      QueryDocumentSnapshot<Object?> document = stores.docs[i];
      storesAndProducts[document.id] = [];
    }
    for (Map<dynamic, dynamic> product in products) {
      for (String storeId in storesAndProducts.keys) {
        if (await isProductFromStore(product['product_id'], storeId)) {
          storesAndProducts[storeId]!.add(product);
        }
      }
    }
    for (String storeId in storesAndProducts.keys) {
      await makeSales(
          storesAndProducts[storeId]!, storeId, orderId, deliveryProcessId);
    }
  }

  static Future<bool> buyProducts(List<Map<dynamic, dynamic>> products) async {
    int orderId = Random().nextInt(1000000);
    int deliveryProcessId = Random().nextInt(1000000);
    String now = DateFormat("hh:mm dd-MM-yyyy").format(DateTime.now());
    try {
      ////////////////  MAKE THE SALE(S)
      prepareSales(products, orderId, deliveryProcessId);

      ////////////////  MAKE THE ORDER
      DocumentReference orderDocument = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId.toString());
      orderDocument.set({
        'delivery_processId': deliveryProcessId,
        'date': now,
        'products': products,
        'user_id': uid,
      });

      //////////////// MAKE THE DELIVERY PROCESS
      DocumentReference deliveryProcessDocument = FirebaseFirestore.instance
          .collection('delivery_processes')
          .doc(deliveryProcessId.toString());
      deliveryProcessDocument.set({
        'delivery_man_id': await getRandomDeliveryMan(),
        'order_id': orderId,
        'state': PREPARING,
      });
      //////////////// UPDATE THE QUANTITY AVAILABLE FOR EACH PRODUCT
      for (Map<dynamic, dynamic> element in products) {
        DocumentSnapshot productDetail = await FirebaseFirestore.instance
            .collection('products')
            .doc(element['product_id'])
            .get();
        int total = productDetail.get('quantity');
        total -= int.parse(element['buy_quantity'].toString());
        FirebaseFirestore.instance
            .collection('products')
            .doc(element['product_id'])
            .update({'quantity': total});
      }
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  static Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  }

  static bool invalidParam(String param) {
    return param == "";
  }

  static Future<void> updateProduct(String productId, String price,
      String quantity, String description, String name) async {
    Map<String, dynamic> params = {
      'quantity': quantity,
      'price': price,
      'description': description,
      'name': name
    };
    if (invalidParam(quantity)) params.remove('quantity');
    if (invalidParam(price)) params.remove('price');
    if (invalidParam(description)) params.remove('description');
    if (invalidParam(name)) params.remove('name');
    if (params.containsKey('quantity')) {
      params['quantity'] = int.parse(quantity);
    }
    if (params.containsKey('price')) {
      params['price'] = int.parse(price);
    }
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update(params);
  }

  static Future<List<String>> getDeliveryManIdAndStateFromOrder(
      String deliveryProcessId) async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('delivery_processes').get();
    for (var document in snap.docs) {
      try {
        if (document.id == deliveryProcessId) {
          return [document.get('delivery_man_id'), document.get('state')];
        }
      } catch (e) {
        print(e.toString());
        continue;
      }
    }
    return [NONE];
  }

  static Future<List<String>> getDeliveryManInfo(String deliveryManId) async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('users').get();
    for (var document in snap.docs) {
      try {
        if (document.get('delivery_man_id') == deliveryManId) {
          return [document.get('name'), document.get('email')];
        }
      } catch (e) {
        print(e.toString());
        continue;
      }
    }
    return [NONE];
  }

  static Future<List<String>> getOrdersByUid(String uid) async {
    List<String> result = [];
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('orders').get();
    for (var document in snap.docs) {
      try {
        if (document.get('user_id') == uid) {
          result.add(document.id);
        }
      } catch (e) {
        print(e.toString());
        continue;
      }
    }
    return result;
  }

  static Future<List<String>> getSalesByUid(String uid) async {
    DocumentSnapshot userDetail =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String storeId = userDetail.get('store_id');
    List<String> result = [];
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('sales').get();
    for (var document in snap.docs) {
      try {
        if (document.get('store_id') == storeId) {
          result.add(document.id);
        }
      } catch (e) {
        print(e.toString());
        continue;
      }
    }
    return result;
  }

  static Future<String> getRandomDeliveryMan() async {
    List<String>? deliveryMans = [];
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('users').get();
    for (var document in snap.docs) {
      try {
        if (document.get('role') == DELIVERY_MAN) {
          deliveryMans.add(document.get('delivery_man_id'));
        }
      } catch (e) {
        print(e.toString());
        continue;
      }
    }
    if (deliveryMans.isEmpty) return "dm1";
    if (deliveryMans.length == 1) return deliveryMans[0];
    int choice = Random().nextInt(deliveryMans.length);
    return deliveryMans[choice];
  }

  static Future<bool> addToken(String token) async {
    DocumentSnapshot tokenDetail =
        await FirebaseFirestore.instance.collection('tokens').doc(token).get();

    int remaining = 0;

    // check if the token exists.
    try {
      remaining = tokenDetail.get('remaining');
    } catch (e) {
      print(e.toString());
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
