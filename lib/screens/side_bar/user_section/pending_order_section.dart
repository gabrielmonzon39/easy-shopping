// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/order_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendingOrderSection extends StatefulWidget {
  const PendingOrderSection({Key? key}) : super(key: key);
  @override
  PendingOrderBuilder createState() => PendingOrderBuilder();
}

class PendingOrderBuilder extends State<PendingOrderSection> {
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

  int i = 0;
  bool change = true;
  List<String> deliversNames = [];
  List<String> deliversEmails = [];

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

    //if (state == PREPARING) state = "Preparando";
    //if (state == ONTHEWAY) state = "En camino";
    //if (state == SERVED) state = "Finalizado";
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

  Future<bool> getPendingOrders() async {
    QuerySnapshot snapOrders =
        await FirebaseFirestore.instance.collection('orders').get();
    QuerySnapshot snapDelivery =
        await FirebaseFirestore.instance.collection('delivery_processes').get();
    QuerySnapshot snapUsers =
        await FirebaseFirestore.instance.collection('delivery_mans').get();
    for (var document in snapOrders.docs) {
      try {
        if (document.get('user_id') == uid!) {
          int del = document.get('delivery_processId');
          for (var document2 in snapDelivery.docs) {
            if (document2.id == del.toString() &&
                (document2.get('state') == PREPARING ||
                    document2.get('state') == ONTHEWAY)) {
              String delManId = document2.get('delivery_man_id');
              String _delName = "";
              String _delEmail = "";
              for (var document3 in snapUsers.docs) {
                try {
                  //print("${document3.id} -> $delManId");
                  if (delManId == NONE) {
                    _delName = NONE;
                    _delEmail = NONE;
                  }
                  if (delManId == DELIVERY_PENDING) {
                    _delName = DELIVERY_PENDING;
                    _delEmail = DELIVERY_PENDING;
                  }
                  if (document3.id == delManId) {
                    _delName = document3.get('name');
                    _delEmail = document3.get('email');
                  }
                } catch (e) {
                  continue;
                }
              }
              String state = document2.get('state') + "";
              list.add(Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderView(
                                      id: document.id,
                                      date: document.get('date'),
                                      deliverManIdName: _delName,
                                      deliverManIdEmail: _delEmail,
                                      state: state,
                                    )),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ternaryColor;
                            },
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Compra : ${document.id}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Fecha : ${document.get('date').toString()}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Total : Q${document.get('total')}.00",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ));
            }
          }
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
    deliversNames.clear();
    deliversEmails.clear();
    //if (state == null && document != null) getState(document!);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Órdenes pendientes"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          decoration: BoxDecoration(
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
                      future: getPendingOrders(),
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
