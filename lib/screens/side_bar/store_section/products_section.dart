// ignore_for_file: empty_catches, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({Key? key}) : super(key: key);
  @override
  ProductsSectionBuilder createState() => ProductsSectionBuilder();
}

class ProductsSectionBuilder extends State<ProductsSection> {
  String? id;
  bool availableRefresh = true;

  Future<void> calculateStoreId() async {
    final storeId = await FirebaseFS.getStoreId(uid!);
    availableRefresh = false;
    setState(() {
      id = storeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (availableRefresh) calculateStoreId();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Mis productos"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////////
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder:
                          (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                        if (usersnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: usersnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot<Object?>? document =
                                  usersnapshot.data?.docs[index];
                              try {
                                if (document!.get('store_id') == id!) {
                                  print("--------- " + document.get('image'));
                                  return Card(
                                    color: Colors.amber[50],
                                    margin: const EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.pink[50],
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: ListTile(
                                        leading: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/easy-shopping-01.appspot.com/o/000%2Fs1%2FFB_IMG_1660967824513.jpg?alt=media&token=86bff2bc-ff3a-4cca-b612-8b47e03ade43',
                                          width: 50,
                                        ),
                                        title: Text(
                                          document.get('name'),
                                          style: const TextStyle(
                                              fontSize: 19,
                                              color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          'Q${document.get('price')}\tUnidades:${document.get('quantity')}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print(e.toString());
                                print("Fallooo");
                              }
                              return const SizedBox(
                                width: 0,
                                height: 0,
                              );
                            },
                          );
                        }
                      },
                    )
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ));
  }
}
