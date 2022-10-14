// ignore_for_file: empty_catches, must_be_immutable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/product_bought.dart';
import 'package:easy_shopping/widgets/best_selling_product_view.dart';
import 'package:flutter/material.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);
  @override
  IncomeBuilder createState() => IncomeBuilder();
}

class IncomeBuilder extends State<Income> {
  List<Widget> list = [];
  Widget? result;

  int places = 4;
  final quantityController = TextEditingController();

  List<ProductBought> products = [];

  int comparison(ProductBought a, ProductBought b) {
    if (a.bought! > b.bought!) {
      return -1;
    } else if (a.bought! < b.bought!) {
      return 1;
    }
    return 0;
  }

  List<Map<String, dynamic>> parse(List<dynamic> products) {
    List<Map<String, dynamic>> mapProducts = [];
    for (dynamic map in products) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
    return mapProducts;
  }

  Future<Widget> getProduct(ProductBought pb, int pos, String storeId) async {
    DocumentSnapshot productDetail = await FirebaseFirestore.instance
        .collection('products')
        .doc(pb.id)
        .get();

    QuerySnapshot snapSales =
        await FirebaseFirestore.instance.collection('sales').get();

    int money = 0;

    for (var sales in snapSales.docs) {
      if (sales.get('store_id') == storeId) {
        List<dynamic> products = sales.get('products');
        List<Map<String, dynamic>> mapProducts = parse(products);
        for (var mapP in mapProducts) {
          if (mapP['product_id'] == pb.id) {
            money += ((mapP['price'] * mapP['buy_quantity']) as int);
          }
        }
      }
    }
    return BestSellingProductView(
      pos: pos,
      name: productDetail.get('name'),
      image: productDetail.get('image'),
      boughtTimes: pb.bought,
      money: money,
    );
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

    for (int i = 0; i < min(places, products.length); i++) {
      list.add(await getProduct(products[i], i + 1, storeId));
    }

    result = Column(
      children: list,
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    list = [];
    products.clear();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: quantityController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Cantidad",
                          hintStyle: TextStyle(
                            color: Color(0xffA6B0BD),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                            borderSide: BorderSide(color: secondaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                            borderSide: BorderSide(color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            places = int.parse(quantityController.text);
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.green;
                            },
                          ),
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
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
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
