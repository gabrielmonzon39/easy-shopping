// ignore_for_file: empty_catches, must_be_immutable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/product_bought.dart';
import 'package:flutter/material.dart';

class BestSellingProducts extends StatefulWidget {
  const BestSellingProducts({Key? key}) : super(key: key);
  @override
  BestSellingProductsBuilder createState() => BestSellingProductsBuilder();
}

class BestSellingProductsBuilder extends State<BestSellingProducts> {
  List<Widget> list = [];
  Widget? result;

  static const int places = 3;

  List<ProductBought> products = [];

  int comparison(ProductBought a, ProductBought b) {
    if (a.bought! > b.bought!) {
      return -1;
    } else if (a.bought! < b.bought!) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<bool> calculateBestSellingProducts() async {
    String storeId = await FirebaseFS.getStoreId(uid!);
    QuerySnapshot snapProducts =
        await FirebaseFirestore.instance.collection('products').get();

    for (var product in snapProducts.docs) {
      if (product.get('store_id') == storeId) {
        products.add(ProductBought(product.id, product.get('bought')));
      }
    }

    products.sort(comparison);

    for (int i = 0; i < min(places, products.length); i++) {}

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Productos más vendidos"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          child: SizedBox(
            height: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////////
                    FutureBuilder<bool>(
                        future: calculateBestSellingProducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
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
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
