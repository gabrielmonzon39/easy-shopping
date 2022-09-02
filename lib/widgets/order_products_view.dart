// ignore_for_file: must_be_immutable, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/widgets/delivery_man_view.dart';
import 'package:easy_shopping/widgets/single_ordered_product_view.dart';
import 'package:flutter/material.dart';

class OrderProducts extends StatelessWidget {
  String? deliveryProcessId;
  List<dynamic>? products;
  List<Map<String, dynamic>> mapProducts = [];
  String? state;

  OrderProducts({
    Key? key,
    @required this.deliveryProcessId,
    @required this.products,
  }) : super(key: key);

  void parse() {
    for (dynamic map in products!) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
  }

  Widget getOrderedProducts() {
    List<Widget> list = [];
    for (Map<String, dynamic> product in mapProducts) {
      list.add(SingleOrderedProductView(
          productId: product['product_id'],
          buyQuantity: product['buy_quantity'].toString()));
      list.add(const SizedBox(
        height: 20,
      ));
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    parse();
    return Container(
      color: secondaryColor,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Número de compra: $deliveryProcessId',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          /////////////////////////  DELIVERY MAN   ///////////////////////////////////////
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('delivery_processes')
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
              if (usersnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: usersnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Object?>? document =
                        usersnapshot.data?.docs[index];
                    try {
                      if (document!.id == deliveryProcessId) {
                        state = document.get('state');
                        return Column(
                          children: [
                            const Text(
                              'Entregado por: ',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            DeliveryManView(
                                deliveryManId: document.get('delivery_man_id')),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Estado: $state',
                              style: const TextStyle(
                                  fontSize: 19, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        );
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    );
                  },
                );
              }
            },
          ),
          /////////////////////////  PRODUCTS     ///////////////////////////////////////
          getOrderedProducts(),

          /*StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
              if (usersnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: usersnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Object?>? document =
                        usersnapshot.data?.docs[index];
                    try {
                      if (document!.get('user_id') == uid) {
                        return OrderProducts(
                          deliveryProcessId:
                              document.get('delivery_processId').toString(),
                          products: document.get('products'),
                        );
                      }
                    } catch (e) {}
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    );
                  },
                );
              }
            },
          )*/
          ////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}
