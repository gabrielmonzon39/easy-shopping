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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: ternaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(children: [
        Text(
          storeName!,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 35, color: Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
        for (ProductInfo pi in products!)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  pi.name!,
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
                      pi.image!,
                      width: 150,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Q${pi.price!.toString()}',
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
                            'Cantidad: ${pi.buyQuantity!.toString()}',
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
                'Total: Q${pi.getTotal().toString()}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        totalInStore(),
      ]),
    );
  }
}
