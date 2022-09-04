import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class ShoppingCartSection extends StatefulWidget {
  const ShoppingCartSection({Key? key}) : super(key: key);
  @override
  ShoppingCartBuilder createState() => ShoppingCartBuilder();
}

class ShoppingCartBuilder extends State<ShoppingCartSection> {
  List<Widget> listTemp = [];
  List<Widget> list = [];
  Widget? result;
  int total = 0;

  Future<void> getOrderedProducts() async {
    String productId = "";
    String buyQuantity = "";
    int? total;
    for (Map<String, dynamic> product in myShoppingCart!.get()) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ElevatedButton(
                    onPressed: () {
                      myShoppingCart!.remove(productId);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShoppingCartSection(),
                          ));
                    },
                    child: const Icon(
                      Icons.close,
                    )),
              ],
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
                              fontSize: 20,
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
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                  fontSize: 20,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ));
      listTemp.add(const SizedBox(
        height: 10,
      ));
    }
  }

  Future<bool> getProducts() async {
    listTemp.add(const SizedBox(
      height: 20,
    ));
    await getOrderedProducts();
    list.add(Align(
        alignment: Alignment.centerLeft,
        child: Container(
          color: Colors.white,
          child: Column(children: listTemp),
        )));
    list.add(const SizedBox(
      height: 40,
    ));
    listTemp = [];
    result = Column(
      children: list,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text("Carrito de compras"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!myShoppingCart!.isEmpty())
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.red;
                        },
                      ),
                    ),
                    onPressed: () {
                      myShoppingCart!.clear();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShoppingCartSection(),
                          ));
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
              if (!myShoppingCart!.isEmpty())
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.green;
                        },
                      ),
                    ),
                    onPressed: () async {
                      // pendiente
                      bool result =
                          await FirebaseFS.buyProducts(myShoppingCart!.get());
                      myShoppingCart!.clear();
                      if (!result) {
                        showDialog(
                            context: context,
                            builder: (ctx) => const AlertDialog(
                                  title: Text("Ha ocurrido un error"),
                                ));
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Productos comprados"),
                              content: Text(
                                  "Sus productos han sido comprados, el total a cancelar es de Q${total.toString()}"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(true);
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
                    child: const Text(
                      'Comprar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ////////////////////////////////////////////////////////////////
          Expanded(
              child: SingleChildScrollView(
            child: FutureBuilder<bool>(
                future: getProducts(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
    );
  }
}
