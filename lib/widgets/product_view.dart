// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/extra/user/buy_product.dart';
import 'package:easy_shopping/screens/side_bar/store_section/products_section.dart';
import 'package:flutter/material.dart';

class ProductView extends StatelessWidget {
  String? id;
  String? name;
  String? description;
  String? originalDescription;
  String? price;
  String? quantity;
  String? imageURL;

  bool? isUser;

  bool? hasOffer;
  String? offerPrice;

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  final limitDescriptionSize = 25;

  ProductView({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.quantity,
    @required this.imageURL,
    @required this.isUser,
    @required this.hasOffer,
    @required this.offerPrice,
  }) : super(key: key);

  void manageDescription() {
    originalDescription = description!;
    if (description!.length > limitDescriptionSize) {
      description = description!.substring(0, limitDescriptionSize);
      description = "${description!}...";
    }
  }

  @override
  Widget build(BuildContext context) {
    int price_ = hasOffer! ? int.parse(offerPrice!) : int.parse(price!);
    manageDescription();
    if (isUser!) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyProduct(
                  id: id,
                  name: name,
                  description: originalDescription,
                  price: price_.toString(),
                  quantity: quantity,
                  imageURL: imageURL,
                ),
              ));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Colors.white;
            },
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.network(
                imageURL!,
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    /*Text(
                      description!,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Q$price_.00',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (hasOffer!)
                          Text(
                            'Q$price.00',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '$quantity unidades',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageURL!,
                height: 100,
                width: 100,
              ),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Q$price.00',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$quantity unidades',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Modifique los siguientes campos"),
                          content: SizedBox(
                            height: 190,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextField(
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  controller: nameController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Nombre",
                                    hintStyle: TextStyle(
                                      color: Color(0xffA6B0BD),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.production_quantity_limits,
                                      color: Colors.black,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                  ),
                                ),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  controller: descriptionController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Descripción",
                                    hintStyle: TextStyle(
                                      color: Color(0xffA6B0BD),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.production_quantity_limits,
                                      color: Colors.black,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        controller: priceController,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Precio",
                                          hintStyle: TextStyle(
                                            color: Color(0xffA6B0BD),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          prefixIcon: Icon(
                                            Icons.production_quantity_limits,
                                            color: Colors.black,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(200),
                                            ),
                                            borderSide: BorderSide(
                                                color: secondaryColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(200),
                                            ),
                                            borderSide: BorderSide(
                                                color: secondaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        controller: quantityController,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Existencias",
                                          hintStyle: TextStyle(
                                            color: Color(0xffA6B0BD),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          prefixIcon: Icon(
                                            Icons.production_quantity_limits,
                                            color: Colors.black,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(200),
                                            ),
                                            borderSide: BorderSide(
                                                color: secondaryColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(200),
                                            ),
                                            borderSide: BorderSide(
                                                color: secondaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                await FirebaseFS.updateProduct(
                                    id!,
                                    priceController.text,
                                    quantityController.text,
                                    descriptionController.text,
                                    nameController.text);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductsSection(),
                                    ));
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return const Color.fromARGB(255, 156, 146, 48);
                        },
                      ),
                    ),
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      BuildContext dialogContext;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            dialogContext = context;
                            return AlertDialog(
                              title: Text("Borrar producto $name"),
                              content: const Text(
                                  "Si borra el producto, ya no podrá recuperar sus datos y nos será visible para sus clientes."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFS.deleteProduct(id!);
                                    Navigator.pop(dialogContext);
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.red;
                        },
                      ),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
