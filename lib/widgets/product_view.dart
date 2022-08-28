// ignore_for_file: must_be_immutable
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/screens/extra/user/buy_product.dart';
import 'package:flutter/material.dart';

class ProductView extends StatelessWidget {
  String? id;
  String? name;
  String? description;
  String? price;
  String? quantity;
  String? imageURL;
  int? color;
  bool? isUser;

  ProductView(
      {Key? key,
      @required this.id,
      @required this.name,
      @required this.description,
      @required this.price,
      @required this.quantity,
      @required this.imageURL,
      @required this.isUser,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUser!) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyProduct(
                  id: id,
                  name: name,
                  description: description,
                  price: price,
                  quantity: quantity,
                  imageURL: imageURL,
                ),
              ));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return ternaryColor;
            },
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Image.network(
                imageURL!,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              description!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Q$price',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '$quantity unidades',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Image.network(
              imageURL!,
              height: 100,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            description!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Q$price',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '$quantity unidades',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ternaryColor;
                    },
                  ),
                ),
                child: const Text(
                  "Editar",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.red;
                    },
                  ),
                ),
                child: const Text(
                  "Eliminar",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
