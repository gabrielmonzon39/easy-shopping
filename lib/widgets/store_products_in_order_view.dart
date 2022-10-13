// ignore_for_file: must_be_immutable

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/product_infor.dart';
import 'package:flutter/material.dart';

class StoreProductsInOrderView extends StatelessWidget {
  String? storeName;
  List<ProductInfo>? products;

  StoreProductsInOrderView(
      {Key? key, @required this.storeName, @required this.products})
      : super(key: key);

  Widget totalInStore() {
    int total = 0;
    for (ProductInfo pi in products!) {
      total += pi.getTotal();
    }
    return Text(
      'Total en tienda: ${total.toString()}',
      textAlign: TextAlign.left,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ternaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Text(
              storeName!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 35,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            for (ProductInfo pi in products!)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Image.network(
                        pi.image!,
                        height: 120,
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 5, top: 0, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                pi.name!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.white),
                              ),
                              Text(
                                'Precio: Q${pi.price!.toString()}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Cantidad: ${pi.buyQuantity!.toString()}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total: Q${pi.getTotal().toString()}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            totalInStore(),
            const SizedBox(
              height: 15,
            ),
          ]),
        ),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}
