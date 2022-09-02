// ignore_for_file: empty_catches, must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class StoreProduct extends StatefulWidget {
  String? storeId;
  String? name;
  int? color;

  StoreProduct(
      {Key? key,
      @required this.storeId,
      @required this.name,
      @required this.color})
      : super(key: key);
  @override
  StoreProductBuilder createState() =>
      StoreProductBuilder(storeId: storeId, name: name, color: color);
}

class StoreProductBuilder extends State<StoreProduct> {
  String? storeId;
  String? name;
  int? color;
  bool availableRefresh = true;

  StoreProductBuilder(
      {@required this.storeId, @required this.name, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text(name!),
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
                  height: 10,
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
                                if (document!.get('store_id') == storeId! &&
                                    document.get('quantity') != 0) {
                                  return Column(
                                    children: [
                                      ProductView(
                                        id: document.id,
                                        name: document.get('name'),
                                        description:
                                            document.get('description'),
                                        price: document.get('price').toString(),
                                        quantity:
                                            document.get('quantity').toString(),
                                        imageURL: document.get('image'),
                                        isUser: true,
                                      ),
                                      const SizedBox(
                                        height: 20,
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
                    )
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
                const SizedBox(
                  height: 500,
                ),
              ],
            ),
          ),
        ));
  }
}
