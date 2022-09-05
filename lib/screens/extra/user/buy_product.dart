// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class BuyProduct extends StatefulWidget {
  String? id;
  String? name;
  String? description;
  String? price;
  String? quantity;
  String? imageURL;
  double buyQuantity = 1;

  BuyProduct({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.quantity,
    @required this.imageURL,
  }) : super(key: key);

  @override
  BuyProductBuilder createState() => BuyProductBuilder(
        id: id,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        imageURL: imageURL,
      );
}

class BuyProductBuilder extends State<BuyProduct> {
  String? id;
  String? name;
  String? description;
  String? price;
  String? quantity;
  String? imageURL;
  double buyQuantity = 1;

  BuyProductBuilder({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.quantity,
    @required this.imageURL,
  });

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
                    Center(
                      child: Text(
                        name!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            imageURL!,
                            height: 220,
                            width: 220,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 75,
                                ),
                                Text(
                                  'Q$price',
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
                      height: 30,
                    ),
                    Text(description!,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Cantidad: ${buyQuantity.toInt()}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    Row(
                      children: [
                        TextButton(
                          child: const Text(
                            "-",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              if (buyQuantity - 1 >= 1) {
                                buyQuantity--;
                              }
                            });
                          },
                        ),
                        Slider(
                          min: 1,
                          max: double.parse(quantity!),
                          value: buyQuantity,
                          divisions: (int.parse(quantity!) == 1)
                              ? 1
                              : int.parse(quantity!) - 1,
                          activeColor: primaryColor,
                          inactiveColor: ternaryColor,
                          thumbColor: Colors.white,
                          label: '${buyQuantity.round()}',
                          onChanged: (value) {
                            setState(() {
                              buyQuantity = value;
                            });
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "+",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              if (buyQuantity + 1 <= int.parse(quantity!)) {
                                buyQuantity++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                Map<dynamic, dynamic> product = {
                                  'product_id': id,
                                  'buy_quantity':
                                      int.parse(buyQuantity.toStringAsFixed(0)),
                                };
                                List<Map<dynamic, dynamic>> order = [product];
                                bool result =
                                    await FirebaseFS.buyProducts(order);
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
                                  builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        "¡Compra realizada con éxito!"),
                                    content: const Text(
                                        "Puede ver su compra en el historial de compras."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(result);
                                          Navigator.pop(context, result);
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("Aceptar"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                "Comprar",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Colors.green;
                                  },
                                ),
                              ),
                              onPressed: () async {
                                Map<String, dynamic> product = {
                                  'product_id': id,
                                  'buy_quantity':
                                      int.parse(buyQuantity.toStringAsFixed(0)),
                                };
                                myShoppingCart!.push(product);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        "¡Producto agregado al carrito!"),
                                    content: const Text(
                                        "Para finalizar su compra, vaya a la sección de carrito de compras."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
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
                                  ),
                                );
                              },
                              child: const Icon(Icons.shopping_cart),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
