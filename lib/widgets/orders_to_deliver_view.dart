// ignore_for_file: must_be_immutable, no_logic_in_create_state, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/notifications.dart';
import 'package:easy_shopping/model/product_infor.dart';
import 'package:easy_shopping/widgets/store_products_in_order_view.dart';
import 'package:flutter/material.dart';

class OrdersToDeliverView extends StatefulWidget {
  String? id;
  String? name;
  String? home;
  String? date;
  String? deliveryProcessId;
  String? deliveryManId;
  String? state;
  String? userId;

  OrdersToDeliverView({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.home,
    @required this.deliveryManId,
    @required this.deliveryProcessId,
    @required this.date,
    @required this.state,
    @required this.userId,
  }) : super(key: key);

  @override
  OrdersToDeliverViewBuilder createState() => OrdersToDeliverViewBuilder(
        id: id,
        name: name,
        home: home,
        deliveryProcessId: deliveryProcessId,
        deliveryManId: deliveryManId,
        date: date,
        state: state,
        userId: userId,
      );
}

class OrdersToDeliverViewBuilder extends State<OrdersToDeliverView> {
  String? id;
  String? name;
  String? home;
  String? date;
  String? deliveryProcessId;
  String? deliveryManId;
  String? state;
  String? userId;
  String stateText = "";
  int totalOrder = 0;
  List<dynamic>? products;
  List<Map<String, dynamic>> mapProducts = [];
  List<Widget> listTemp = [];
  Widget? result;
  Map<String, List<ProductInfo>?> storeProducts = {};
  String? imageNotification;

  OrdersToDeliverViewBuilder({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.home,
    @required this.deliveryManId,
    @required this.deliveryProcessId,
    @required this.date,
    @required this.state,
    @required this.userId,
  });

  void parse() {
    mapProducts = [];
    for (dynamic map in products!) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
  }

  Future<bool> getOrderedProducts() async {
    String? productId;
    String? storeId;
    String? productName;
    String? storeName;
    String? image;
    int? buyQuantity;
    int? price;

    DocumentSnapshot orderDetails =
        await FirebaseFirestore.instance.collection('orders').doc(id).get();
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
      imageNotification = image;

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

    result = Column(
      children: listTemp,
    );
    listTemp = [];
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (state == PREPARING) stateText = "Preparando";
    if (state == ONTHEWAY) stateText = "En camino";
    if (state == SERVED) stateText = "Finalizado";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text("Compra $id"),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return 0;
                    }
                    return 0;
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.green;
                  },
                ),
              ),
              onPressed: () async {
                BuildContext dialogContext;
                String? title, description;

                if (state == PREPARING) {
                  title = "Pedido preparado";
                  description =
                      "¿Desea notificarle al usuario ${name!} que su pedido ya va en camino?";
                }
                if (state == ONTHEWAY || state == SERVED) {
                  title = "Finalizar pedido";
                  description =
                      "¿Desea finalizar el pedido de la persona ${name!}?";
                }
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      dialogContext = context;
                      return AlertDialog(
                        title: Text(title!),
                        content: Text(description!),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              if (state == PREPARING) {
                                sendNotifications(
                                    userId!,
                                    "Compra $id",
                                    "Su compra está en camino.",
                                    imageNotification!);
                                state = ONTHEWAY;
                              } else if (state == ONTHEWAY) {
                                sendNotifications(
                                    userId!,
                                    "Compra $id",
                                    "Su compra ha sido entregada.",
                                    imageNotification!);
                                state = SERVED;
                              } else if (state == SERVED) {
                                state = SERVED;
                              }
                              await FirebaseFS.changeState(
                                  deliveryProcessId!, state!);
                              // MODALERT
                              Navigator.of(context).pop();
                              if (state == SERVED) {
                                Navigator.of(context).pop();
                                return;
                              }
                              setState(() {
                                storeProducts = {};
                                listTemp = [];
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(14),
                              child: const Text("Aceptar"),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: const Icon(Icons.check),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Número de compra: $id',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Fecha: $date',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Estado: $stateText',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  color: Colors.amber[50],
                  margin: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.pink[50],
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: ListTile(
                      leading: const Icon(
                        Icons.house,
                        size: 50,
                      ),
                      title: Text(
                        name!,
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                      ),
                      subtitle: Text(
                        home!,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ////////////////////////////////////////////////////////////
                FutureBuilder<bool>(
                    future: getOrderedProducts(),
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
                      return Column(
                        children: const [Text("Error")],
                      );
                    }),
                ////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
