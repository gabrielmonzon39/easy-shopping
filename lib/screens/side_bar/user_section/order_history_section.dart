import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/order_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistorySection extends StatefulWidget {
  const OrderHistorySection({Key? key}) : super(key: key);
  @override
  OrderHistoryBuilder createState() => OrderHistoryBuilder();
}

class OrderHistoryBuilder extends State<OrderHistorySection> {
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

  void parse() {
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

  Future<void> getOrderedProducts() async {
    String productId = "";
    String buyQuantity = "";
    int? total;
    for (Map<String, dynamic> product in mapProducts) {
      productId = product['product_id'];
      buyQuantity = product['buy_quantity'].toString();
      DocumentSnapshot productDetails = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      total = (int.parse(buyQuantity) * productDetails.get('price')) as int?;
      this.total += total!;
      listTemp.add(Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: ternaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                productDetails.get('name'),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    productDetails.get('image'),
                    width: 150,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Q${productDetails.get('price').toString()}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Cantidad: $buyQuantity',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
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
                  fontSize: 25,
                  color: Colors.white),
            ),
          ],
        ),
      ));

      listTemp.add(const SizedBox(
        height: 10,
      ));
    }
  }

  Future<void> orderByUid(QueryDocumentSnapshot<Object?> document) async {
    deliveryProcessId = document.get('delivery_processId').toString();
    String date = document.get('date').toString();
    products = document.get('products');
    getDeliveryManAndState();
    parse();
    //await getOrderedProducts();
  }

  Future<void> getDeliveryManAndState() async {
    List<String> data =
        await FirebaseFS.getDeliveryManIdAndStateFromOrder(deliveryProcessId!);
    deliverManId = data[0];
    state = data[1];
    if (state == PREPARING) state = "Preparando";
    if (state == ONTHEWAY) state = "En camino";
    if (state == SERVED) state = "Finalizado";
    List<String> data2 = await FirebaseFS.getDeliveryManInfo(deliverManId!);
    deliverManIdName = data2[0];
    deliverManIdEmail = data2[1];
  }

  void getDeliveryManInfo(String id) async {
    List<String> data = await FirebaseFS.getDeliveryManInfo(deliverManId!);
    deliverManIdName = data[0];
    deliverManIdEmail = data[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Historial de compras"),
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
                Expanded(
                    child: ////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////
                        StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                    if (usersnapshot.connectionState ==
                        ConnectionState.waiting) {
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
                            DateTime date = parseDate(document!.get('date'));
                            if (document.get('user_id') == uid! &&
                                date.isAfter(DateTime.parse(initialPick)) &&
                                date.isBefore(DateTime.parse(endPick))) {
                              orderByUid(document);
                              return Column(
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
                                                    deliverManIdName:
                                                        deliverManIdName,
                                                    deliverManIdEmail:
                                                        deliverManIdEmail,
                                                    state: state,
                                                  )),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            return ternaryColor;
                                          },
                                        ),
                                      ),
                                      child: Text(
                                        "Compra : ${document.id}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
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
                    ////////////////////////////////////////////////////////////////,
                    ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
