// ignore_for_file: must_be_immutable, no_logic_in_create_state, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class ActiveOrderView extends StatelessWidget {
  String? id;
  String? name;
  String? home;
  String? date;
  String? deliveryProcessId;
  String? deliveryManId;
  String? state;
  int totalOrder = 0;
  List<dynamic>? products;
  List<Map<String, dynamic>> mapProducts = [];
  List<Widget> listTemp = [];
  Widget? result;

  ActiveOrderView({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.home,
    @required this.deliveryManId,
    @required this.deliveryProcessId,
    @required this.date,
    @required this.state,
  }) : super(key: key);

  void parse() {
    mapProducts = [];
    for (dynamic map in products!) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
  }

  Future<bool> getOrderedProducts() async {
    String productId = "";
    String buyQuantity = "";
    int? total;
    DocumentSnapshot orderDetails =
        await FirebaseFirestore.instance.collection('orders').doc(id).get();
    products = orderDetails.get('products');
    totalOrder = 0;
    parse();
    for (Map<String, dynamic> product in mapProducts) {
      productId = product['product_id'];
      buyQuantity = product['buy_quantity'].toString();
      DocumentSnapshot productDetails = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      total = (int.parse(buyQuantity) * productDetails.get('price')) as int?;
      totalOrder += total!;
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
    listTemp.add(
      Text(
        'Total de compra: Q$totalOrder',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
    result = Column(
      children: listTemp,
    );
    listTemp = [];
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (state == PREPARING) state = "Preparando";
    if (state == ONTHEWAY) state = "En camino";
    if (state == SERVED) state = "Finalizado";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text("Compra $id"),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return 0;
                    }
                    return 0;
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.green;
                  },
                ),
              ),
              onPressed: () async {
                BuildContext dialogContext;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      dialogContext = context;
                      return AlertDialog(
                        title: const Text("Aceptar pedido"),
                        content: const Text(
                            "¿Desea aceptar el pedido? Para garantizar la calidad del servicio, deberá entregarlo en menos de 20 minutos."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              await FirebaseFS.assingDeliverMan(
                                  deliveryProcessId!, deliveryManId!);
                              Navigator.of(context, rootNavigator: true)
                                  .pop(true);
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            },
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(14),
                              child: const Text("Aceptar"),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: const Icon(Icons.check),
            )
          ],
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
                Text(
                  'Número de compra: $id',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Fecha: $date',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  color: Colors.amber[50],
                  margin: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.pink[50],
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: ListTile(
                      leading: const Icon(
                        Icons.house,
                        size: 50,
                      ),
                      title: Text(
                        name!,
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                      ),
                      subtitle: Text(
                        home!,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ////////////////////////////////////////////////////////////
                FutureBuilder<bool>(
                    future: getOrderedProducts(),
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
                      return Column(
                        children: const [Text("Error")],
                      );
                    }),
                ////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
