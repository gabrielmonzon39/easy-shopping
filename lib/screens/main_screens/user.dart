// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/side_bar/user_section/information_section.dart';
import 'package:easy_shopping/widgets/store_service_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);
  @override
  UserBuilder createState() => UserBuilder();
}

class UserBuilder extends State<UserMainScreen> {
  final nameController = TextEditingController();
  bool valid = true;
  String? myProjectId;

  String selectedOption = types[types.length - 1];

  BuildContext? myContext;
  List<Widget>? vals;

  void init(BuildContext context) {
    myContext = context;
    vals = [
      const Text("Hola1"),
      const Text("Hola2"),
      ElevatedButton(
          onPressed: () {
            Navigator.push(
              myContext!,
              MaterialPageRoute(
                  builder: (context) => const UserInformationSection()),
            );
          },
          child: const Text("Boton 3")),
    ];
  }

  bool evalConditions(QueryDocumentSnapshot<Object?>? document) {
    if (document == null) return false;
    if (document.id == "8NSZ1ielRBQyriNRwXdx") return false;
    if (document.get('quantity') <= 0) return false;
    return true;
  }

  Future<void> checkProjectofProduct(
      QueryDocumentSnapshot<Object?>? document) async {
    valid = await FirebaseFS.checkProjectofProduct(document!.get('store_id'));
  }

  int count2 = 0;
  List<String> topProducts = [];

  Future<void> topUserProducts() async {
    if (count2 != 0) return;
    topProducts = await FirebaseFS.getTopUserProducts(uid!);
    count2++;
    setState(() {});
  }

  ///////////////////////   Productos Recomendados    ///////////////////////
  List<Widget> listRecommendedProducts = [];
  List<Widget> defaultRecommendedProducts = [];
  List<String> already = [];
  final limit = 5;

  Future<bool> getRecommendedProducts() async {
    myProjectId = await FirebaseFS.getProjectId(uid!);
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('products').get();
    int i = 0;
    for (var document in snap.docs) {
      String projectId =
          await FirebaseFS.getProjectIdFromStore(document.get('store_id'));
      if (projectId != myProjectId) continue;
      Widget productView = ProductView(
        id: document.id,
        name: document.get('name'),
        description: document.get('description'),
        category: document.get('type'),
        price: document.get('price').toString(),
        quantity: document.get('quantity').toString(),
        imageURL: document.get('image'),
        isUser: true,
        hasOffer: document.get('has_offer'),
        offerPrice: document.get('new_price').toString(),
      );
      if (!already.contains(document.id) &&
          evalConditions(document) &&
          topProducts.contains(document.id)) {
        already.add(document.id);
        //print("SE AGREGO A LA RECOMENDADA: ${document.id}");
        listRecommendedProducts.add(productView);
      }
      if (i < limit && !already.contains(document.id)) {
        already.add(document.id);
        //print("SE AGREGO A LA DEFAULT: ${document.id} - $i");
        defaultRecommendedProducts.add(productView);
      }
      i++;
    }
    return true;
  }

  ///////////////////////   Publicidad    ///////////////////////
  List<Widget> listPublicity = [];

  Future<bool> getPublicity() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('publicity').get();
    for (var doc in snap.docs) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('stores')
          .doc(doc.id)
          .get();
      if (document.get('project_id') != myProjectId) continue;
      listPublicity.add(StoreServiceView(
        name: document.get('name'),
        description: document.get('description'),
        imageURL: document.get('image'),
        storeId: document.id,
        color: 0xFF2697FF,
      ));
    }
    return true;
  }

  ///////////////////////   Ofertas       ///////////////////////
  List<Widget> listOfferedProducts = [];

  Future<bool> getOfferedProducts() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('store_offers').get();
    for (var doc in snap.docs) {
      String projectId =
          await FirebaseFS.getProjectIdFromStore(doc.get('store_id'));
      if (projectId != myProjectId) continue;
      Timestamp startTS = doc.get('start');
      DateTime start = startTS.toDate();
      Timestamp endTS = doc.get('end');
      DateTime end = endTS.toDate();
      if (doc.get('active') &&
          start.isBefore(DateTime.now()) &&
          end.isAfter(DateTime.now())) {
        String productId = doc.get('product_id');
        DocumentSnapshot document = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();
        if (document.get('visible')) {
          listOfferedProducts.add(ProductView(
            id: document.id,
            name: document.get('name'),
            description: document.get('description'),
            category: document.get('type'),
            price: document.get('price').toString(),
            quantity: document.get('quantity').toString(),
            imageURL: document.get('image'),
            isUser: true,
            hasOffer: document.get('has_offer'),
            offerPrice: document.get('new_price').toString(),
          ));
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    topUserProducts();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        ///////////////////////   Productos Recomendados    ///////////////////////
        ////////////////////////////////////////////////////////////////
        SizedBox(
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<bool>(
                  future: getRecommendedProducts(),
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
                      ]);
                    } else {
                      // loaded
                      bool? valid = snapshot.data;
                      if (valid!) {
                        if (listRecommendedProducts.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("PRODUCTOS QUE PODR??AN GUSTARTE",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                        child:
                                            defaultRecommendedProducts[index]);
                                  },
                                  itemCount: defaultRecommendedProducts.length,
                                  itemWidth: double.infinity,
                                  layout: SwiperLayout.DEFAULT,
                                  scrollDirection: Axis.horizontal,
                                  loop: true,
                                  index: 0,
                                  autoplay: true,
                                  duration: 6000,
                                ),
                              )
                            ],
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("PRODUCTOS RECOMENDADOS",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                      child: listRecommendedProducts[index]);
                                },
                                itemCount: listRecommendedProducts.length,
                                itemWidth: double.infinity,
                                layout: SwiperLayout.DEFAULT,
                                scrollDirection: Axis.horizontal,
                                loop: true,
                                index: 0,
                                autoplay: true,
                                duration: 6000,
                              ),
                            )
                          ],
                        );
                      }
                    }
                    return Center(
                        child: Column(children: const [
                      Text(
                        "??Ups! Ha ocurrido un error al obtener los datos.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ]));
                  }),
            ],
          ),
        ),

        const SizedBox(
          height: 70,
        ),

        ///////////////////////   Publicidad       ///////////////////////
        //////////////////////////////////////////////////////////////////
        SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<bool>(
                  future: getPublicity(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (!snapshot.hasData) {
                      // not loaded
                      return const Center(child: Text('')
                          // child: CircularProgressIndicator(),
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
                        if (listPublicity.isEmpty) {
                          return const SizedBox(
                            height: 0,
                          );
                        }
                        return SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(child: listPublicity[index]);
                            },
                            itemCount: listPublicity.length,
                            itemWidth: double.infinity,
                            itemHeight: double.infinity,
                            layout: SwiperLayout.DEFAULT,
                            scrollDirection: Axis.horizontal,
                            loop: true,
                            index: 0,
                            autoplay: true,
                            duration: 10000,
                            viewportFraction: 0.9,
                          ),
                        );
                      }
                    }
                    return Center(
                        child: Column(children: const [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "??Ups! Ha ocurrido un error al obtener los datos.",
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
            ],
          ),
        ),

        if (listPublicity.isNotEmpty)
          const SizedBox(
            height: 40,
          ),

        ///////////////////////   Ofertas       ///////////////////////
        const Text("OFERTAS",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
        const SizedBox(
          height: 40,
        ),
        ////////////////////////////////////////////////////////////////
        SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<bool>(
                  future: getOfferedProducts(),
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
                        if (listOfferedProducts.isEmpty) {
                          return const SizedBox(
                            height: 0,
                          );
                        }
                        return SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                  child: listOfferedProducts[index]);
                            },
                            itemCount: listOfferedProducts.length,
                            itemWidth: double.infinity,
                            layout: SwiperLayout.DEFAULT,
                            scrollDirection: Axis.horizontal,
                            loop: true,
                            index: 0,
                            autoplay: true,
                            duration: 6000,
                          ),
                        );
                      }
                    }
                    return Center(
                        child: Column(children: const [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "??Ups! Ha ocurrido un error al obtener los datos.",
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
            ],
          ),
        ),
      ],
    );
  }
}
