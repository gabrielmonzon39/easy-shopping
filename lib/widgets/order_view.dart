// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

class OrderView extends StatelessWidget {
  String? id;
  String? date;
  String? deliverManIdName;
  String? deliverManIdEmail;
  String? state;
  int? totalOrder;

  OrderView({
    Key? key,
    @required this.id,
    @required this.date,
    @required this.deliverManIdName,
    @required this.deliverManIdEmail,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text("Compra $id"),
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

                const Text(
                  'Entregado por: ',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
                ///////////////// DELIVERY MAN CARD ////////////////////////
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
                        Icons.face,
                        size: 50,
                      ),
                      title: Text(
                        deliverManIdName!,
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                      ),
                      subtitle: Text(
                        deliverManIdEmail!,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                ////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Estado: $state',
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                /*ProductView(
                    id: id,
                    name: name,
                    description: description,
                    price: price,
                    quantity: quantity,
                    imageURL: imageURL,
                    isUser: true),*/
                Text(
                  'Total de compra: Q${totalOrder.toString()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
