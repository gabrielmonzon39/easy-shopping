// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/product_infor.dart';
import 'package:easy_shopping/widgets/active_order_view.dart';
import 'package:easy_shopping/widgets/orders_to_deliver_view.dart';
import 'package:easy_shopping/widgets/store_products_in_order_view.dart';
import 'package:flutter/material.dart';

class OrdersToDeliver extends StatefulWidget {
  const OrdersToDeliver({Key? key}) : super(key: key);
  @override
  OrdersToDeliverBuilder createState() => OrdersToDeliverBuilder();
}

class OrdersToDeliverBuilder extends State<OrdersToDeliver> {
  String? deliveryProcessId;
  List<dynamic>? products;
  List<Map<String, dynamic>> mapProducts = [];
  String? state;
  String? deliverManId;
  String? deliverManIdName;
  String? deliverManIdEmail;
  List<Widget> listTemp = [];
  List<Widget> list = [];
  Widget? result;
  int total = 0;
  QueryDocumentSnapshot<Object?>? document;
  bool available = false;

  int i = 0;
  bool change = true;
  List<String> deliversNames = [];
  List<String> deliversEmails = [];
  Map<String, List<ProductInfo>?> storeProducts = {};

  void parse() {
    mapProducts = [];
    for (dynamic map in products!) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
  }

  DateTime parseDate(String dateAndHour) {
    String date = dateAndHour.split(" ").last;
    List<String> formatedDate = date.split("-");
    return DateTime(int.parse(formatedDate[2]), int.parse(formatedDate[1]),
        int.parse(formatedDate[0]));
  }

  Future<void> orderByUid(QueryDocumentSnapshot<Object?> document) async {
    deliveryProcessId = document.get('delivery_processId').toString();
    await getDeliveryManAndState();
  }

  Future<void> getDeliveryManAndState() async {
    List<String> data =
        await FirebaseFS.getDeliveryManIdAndStateFromOrder(deliveryProcessId!);
    deliverManId = data[0];
    List<String> data2 = await FirebaseFS.getDeliveryManInfo(deliverManId!);
    deliverManIdName = data2[0];
    deliverManIdEmail = data2[1];

    deliversNames.add(deliverManIdName!);
    deliversEmails.add(deliverManIdEmail!);
    if (state == null) {
      setState(() {
        state = data[1];
      });
    }
  }

  void getState(QueryDocumentSnapshot<Object?> document) async {
    deliveryProcessId = document.get('delivery_processId').toString();
    List<String> data =
        await FirebaseFS.getDeliveryManIdAndStateFromOrder(deliveryProcessId!);
    //print("-- $deliveryProcessId : ${data[1]} --");
    setState(() {
      state = data[1];
    });
  }

  void getDeliveryManInfo(String id) async {
    List<String> data = await FirebaseFS.getDeliveryManInfo(deliverManId!);
    deliverManIdName = data[0];
    deliverManIdEmail = data[1];
  }

  Future<bool> getActiveOrders() async {
    String? productId;
    String? storeId;
    String? productName;
    String? storeName;
    String? image;
    int? buyQuantity;
    int? price;

    DocumentSnapshot orderDetails = await FirebaseFirestore.instance
        .collection('orders')
        .doc(deliveryProcessId)
        .get();
    products = orderDetails.get('products');

    parse();

    for (Map<String, dynamic> product in mapProducts) {
      // id producto, precio, cantidad
      productId = product['product_id'];
      buyQuantity = product['buy_quantity'];
      price = product['price'];

      // acceder a los detalles del producto
      DocumentSnapshot productDetails = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      // nombre del producto y store id
      productName = productDetails.get('name');
      storeId = productDetails.get('store_id');
      image = productDetails.get('image');

      // acceder a los detalles del prodcuto
      DocumentSnapshot storeDetails = await FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId)
          .get();

      // nombre de la tienda
      storeName = storeDetails.get('name');

      // asociar producto a la tienda
      if (storeProducts.containsKey(storeName!)) {
        storeProducts[storeName]!
            .add(ProductInfo(productName, image, buyQuantity, price));
      } else {
        storeProducts.addEntries([
          MapEntry(
              storeName, [ProductInfo(productName, image, buyQuantity, price)])
        ]);
      }
    }
    // agregar los widgets
    storeProducts.forEach((key, value) {
      listTemp.add(StoreProductsInOrderView(
        storeName: key,
        products: value,
      ));
    });
    if (storeProducts.isEmpty) {
      result = Column(
        children: listTemp,
      );
      listTemp = [];
    } else {
      result = Center(
          child: Column(children: const [
        SizedBox(
          height: 100,
        ),
        Text(
          "No tiene órdenes por entregar por el momento. Vaya a la parte de órdenes activas para buscar unas órdenes que entregar.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 100,
        ),
        Icon(
          Icons.tag_faces,
          size: 100,
        ),
      ]));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    deliversNames.clear();
    deliversEmails.clear();
    //if (state == null && document != null) getState(document!);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Órdenes por entregar"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            height: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ////////////////////////////////////////////////////////////////
                Expanded(
                    child: SingleChildScrollView(
                  child: FutureBuilder<bool>(
                      future: getActiveOrders(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          // not loaded
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          // some error
                          return Column(children: const [
                            Text(
                              "Lo sentimos, ha ocurrido un error",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Icon(
                              Icons.close,
                              size: 100,
                            ),
                          ]);
                        } else {
                          // loaded
                          bool? valid = snapshot.data;
                          if (valid!) {
                            return result!;
                          }
                        }
                        return Center(
                            child: Column(children: const [
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            "¡Ups! Ha ocurrido un error al obtener los datos.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: 100,
                          ),
                        ]));
                      }),
                )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
