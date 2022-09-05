// ignore_for_file: must_be_immutable
import 'package:easy_shopping/screens/extra/user/store_products.dart';
import 'package:flutter/material.dart';

class StoreServiceView extends StatelessWidget {
  String? name;
  String? description;
  String? imageURL;
  String? storeId;
  int? color;

  StoreServiceView(
      {Key? key,
      @required this.name,
      @required this.description,
      @required this.imageURL,
      @required this.storeId,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Color(color!);
              },
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreProduct(
                        storeId: storeId,
                        name: name,
                        color: color,
                      )),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageURL!,
                    width: 100,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              name!,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            description!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
