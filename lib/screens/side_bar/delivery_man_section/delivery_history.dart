// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/order_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryHistory extends StatefulWidget {
  const DeliveryHistory({Key? key}) : super(key: key);
  @override
  DeliveryHistoryBuilder createState() => DeliveryHistoryBuilder();
}

class DeliveryHistoryBuilder extends State<DeliveryHistory> {
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
  String initialPick = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String endPick = DateFormat("yyyy-MM-dd").format(DateTime.now());
  bool valid = false;

  int i = 0;
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
    String deliveryManId =
        (await FirebaseFirestore.instance.collection('users').doc(uid).get())
            .get('delivery_man_id');
    valid = deliverManId == deliveryManId;
    state = data[1];
    if (state == PREPARING) state = "Preparando";
    if (state == ONTHEWAY) state = "En camino";
    if (state == SERVED) state = "Finalizado";
    List<String> data2 = await FirebaseFS.getDeliveryManInfo(deliverManId!);
    deliverManIdName = data2[0];
    deliverManIdEmail = data2[1];

    deliversNames.add(deliverManIdName!);
    deliversEmails.add(deliverManIdEmail!);
  }

  void getDeliveryManInfo(String id) async {
    List<String> data = await FirebaseFS.getDeliveryManInfo(deliverManId!);
    deliverManIdName = data[0];
    deliverManIdEmail = data[1];
  }

  Future<bool> calculateDates() async {
    QuerySnapshot snapOrders =
        await FirebaseFirestore.instance.collection('orders').get();
    for (var document in snapOrders.docs) {
      try {
        DateTime date = parseDate(document.get('date'));

        if (date.isAfter(DateTime.parse(initialPick)
                .subtract(const Duration(days: 1))) &&
            date.isBefore(
                DateTime.parse(endPick).add(const Duration(days: 1)))) {
          await orderByUid(document);
          i++;
          if (valid) {
            list.add(Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        List<String> data1 =
                            await FirebaseFS.getDeliveryManIdAndStateFromOrder(
                                document.get('delivery_processId').toString());
                        List<String> data =
                            await FirebaseFS.getDeliveryManInfo(data1[0]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderView(
                                    id: document.id,
                                    date: document.get('date'),
                                    deliverManIdName: data[0],
                                    deliverManIdEmail: data[1],
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
                            "Fecha : ${document.get('date')}",
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
      } catch (e) {
        print(e.toString());
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Órdenes entregadas"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Fecha inicial : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      initialPick,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? temp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(initialPick),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (temp == null) return;
                        setState(() {
                          initialPick = DateFormat("yyyy-MM-dd").format(temp);
                          if (DateTime.parse(initialPick)
                              .isAfter(DateTime.parse(endPick))) {
                            String aux = endPick;
                            endPick = initialPick;
                            initialPick = aux;
                          }
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
                        Icons.calendar_month,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Fecha final   : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      endPick,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? temp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(endPick),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (temp == null) return;
                        setState(() {
                          endPick = DateFormat("yyyy-MM-dd").format(temp);
                          if (DateTime.parse(endPick)
                              .isBefore(DateTime.parse(initialPick))) {
                            String aux = initialPick;
                            initialPick = endPick;
                            endPick = aux;
                          }
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
                        Icons.calendar_month,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                /////////////////////////////////////////////
                Expanded(
                    child: SingleChildScrollView(
                  child: FutureBuilder<bool>(
                      future: calculateDates(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          // not loaded
                          return const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor)),
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
