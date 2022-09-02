// ignore_for_file: empty_catches, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

class SingleOrderedProductView extends StatelessWidget {
  String? productId;
  String? buyQuantity;
  int total = 0;

  SingleOrderedProductView(
      {Key? key, @required this.productId, @required this.buyQuantity})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: ternaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('products').snapshots(),
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
                      if (document!.id == productId) {
                        total = int.parse(buyQuantity!) *
                            int.parse(document.get('price'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document.get('name'),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.network(
                                    document.get('image'),
                                    width: 150,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 8, bottom: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Q${document.get('price').toString()}',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '$buyQuantity unidades',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Total: Q${total.toString()}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30,
                                  color: Colors.white),
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
        ],
      ),
    );
  }
}
