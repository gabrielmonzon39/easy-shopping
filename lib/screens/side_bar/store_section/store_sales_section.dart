import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class StoreSalesSection extends StatefulWidget {
  const StoreSalesSection({Key? key}) : super(key: key);
  @override
  StoreSalesBuilder createState() => StoreSalesBuilder();
}

class StoreSalesBuilder extends State<StoreSalesSection> {
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

  void parse() {
    for (dynamic map in products!) {
      mapProducts.add(Map<String, dynamic>.from(map));
    }
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

  Future<bool> salesByUid() async {
    final sales = await FirebaseFS.getSalesByUid(uid!);
    for (String sale in sales) {
      DocumentSnapshot saleDetails =
          await FirebaseFirestore.instance.collection('sales').doc(sale).get();
      deliveryProcessId = saleDetails.get('delivery_processId').toString();
      String fecha = saleDetails.get('date').toString();
      products = saleDetails.get('products');
      await getDeliveryManAndState();
      parse();
      listTemp.add(
        const SizedBox(
          height: 15,
        ),
      );
      listTemp.add(Text(
        'Número de compra: $deliveryProcessId',
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontSize: 22,
        ),
      ));
      listTemp.add(const SizedBox(
        height: 40,
      ));
      listTemp.add(Text(
        'Fecha: $fecha',
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 19, color: Colors.white),
      ));
      listTemp.add(const SizedBox(
        height: 25,
      ));
      listTemp.add(const Text(
        'Entregado por: ',
        style: TextStyle(fontSize: 19, color: Colors.white),
      ));
      ///////////////// DELIVERY MAN CARD ////////////////////////
      listTemp.add(Card(
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
              Icons.face,
              size: 50,
            ),
            title: Text(
              deliverManIdName!,
              style: const TextStyle(fontSize: 19, color: Colors.black),
            ),
            subtitle: Text(
              deliverManIdEmail!,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ),
      ));
      ////////////////////////////////////////////////////////////
      listTemp.add(const SizedBox(
        height: 20,
      ));
      listTemp.add(Text(
        'Estado: $state',
        style: const TextStyle(fontSize: 19, color: Colors.white),
      ));
      listTemp.add(
        const SizedBox(
          height: 20,
        ),
      );
      await getOrderedProducts();
      listTemp.add(Text(
        'Total de venta: ${total.toString()}',
        style: const TextStyle(fontSize: 19, color: Colors.white),
      ));
      list.add(Container(
        color: secondaryColor,
        child: Column(children: listTemp),
      ));
      list.add(const SizedBox(
        height: 20,
      ));
      listTemp = [];
    }
    result = Column(
      children: list,
    );
    return true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Historial de ventas"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
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
                    FutureBuilder<bool>(
                        future: salesByUid(),
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
                  ],
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ));
  }
}
