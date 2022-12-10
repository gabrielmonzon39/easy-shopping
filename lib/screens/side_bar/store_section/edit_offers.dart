// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/screens/side_bar/store_section/change_offer.dart';
import 'package:flutter/material.dart';

class EditOffersSection extends StatefulWidget {
  final String storeId;
  const EditOffersSection({Key? key, required this.storeId}) : super(key: key);
  @override
  EditOffersBuilder createState() => EditOffersBuilder(storeId);
}

class EditOffersBuilder extends State<EditOffersSection> {
  String? storeId;
  EditOffersBuilder(this.storeId);

  List<Widget> list = [];
  Widget? result;
  int total = 0;
  QueryDocumentSnapshot<Object?>? document;

  Widget offerView(QueryDocumentSnapshot<Object?>? document, Timestamp start,
      Timestamp end, bool active, String offerId) {
    String status = active ? 'Activa' : 'Inactiva';
    Color color = active ? Colors.green : Colors.red;
    Color offerTextColor = !active ? Colors.green : Colors.red;
    int price_ = document!.get('has_offer')
        ? document.get('new_price')
        : document.get('price');
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeOffer(
                  storeId: storeId!,
                  name: document.get('name'),
                  quantity: document.get('quantity').toString(),
                  price: document.get('new_price').toString(),
                  price_: document.get('price').toString(),
                  imageURL: document.get('image'),
                  offerId: offerId,
                  productId: document.id,
                  active: active,
                  start: start,
                  end: end),
            ));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return color;
          },
        ),
      ),
      child: Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.network(
                        document.get('image')!,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              document.get('name')!,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Q$price_.00',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                if (document.get('has_offer')!)
                                  Text(
                                    'Q${document.get('price')}.00',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: offerTextColor,
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              '${document.get('quantity')} unidades',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ])),
    );
  }

  Future<bool> getOffers() async {
    QuerySnapshot snapOffers = await FirebaseFirestore.instance
        .collection('store_offers')
        .where('store_id', isEqualTo: storeId)
        .get();

    for (final document in snapOffers.docs) {
      try {
        Timestamp start = document.get('start');
        Timestamp end = document.get('end');
        bool active = document.get('active');
        String productId = document.get('product_id');

        QuerySnapshot snapProduct = await FirebaseFirestore.instance
            .collection('products')
            .where(FieldPath.documentId, isEqualTo: productId)
            .get();

        for (final document2 in snapProduct.docs) {
          list.add(offerView(document2, start, end, active, document.id));
        }
      } catch (e) {
        print(e.toString());
        continue;
      }
    }
    result = Column(
      children: list,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    list.clear();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Editar ofertas"),
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
                      future: getOffers(),
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
                                color: Colors.white,
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
                              color: Colors.white,
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
                /////////////////////////////////////////////
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
