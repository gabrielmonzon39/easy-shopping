// ignore_for_file: no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangeOffer extends StatefulWidget {
  final String storeId;
  final String name;
  final String quantity;
  final String price;
  final String price_;
  final String imageURL;
  final String offerId;
  final String productId;
  final bool active;
  final Timestamp start;
  final Timestamp end;
  const ChangeOffer(
      {Key? key,
      required this.storeId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.price_,
      required this.imageURL,
      required this.offerId,
      required this.active,
      required this.start,
      required this.end,
      required this.productId})
      : super(key: key);
  @override
  ChangeOfferBuilder createState() => ChangeOfferBuilder(
      storeId,
      name,
      quantity,
      price,
      price_,
      imageURL,
      offerId,
      active,
      start,
      end,
      productId);
}

class ChangeOfferBuilder extends State<ChangeOffer> {
  final String storeId;
  final String name;
  final String quantity;
  final String price;
  final String price_;
  final String imageURL;
  final String offerId;
  final String productId;
  final bool active;
  final Timestamp start;
  final Timestamp end;

  ChangeOfferBuilder(
      this.storeId,
      this.name,
      this.quantity,
      this.price,
      this.price_,
      this.imageURL,
      this.offerId,
      this.active,
      this.start,
      this.end,
      this.productId);

  final priceController = TextEditingController();
  String? selectedProductId;
  int? selectedProductPrice;
  Map<String, int> productPrices = {};

  DateTime initialPick = DateTime.now();
  DateTime finalPick = DateTime.now();
  bool selected = true;
  bool init = true;

  void ingresarOferta() async {
    try {
      if (int.parse(priceController.text) > int.parse(price_) ||
          int.parse(priceController.text) > int.parse(price)) {
        EasyLoading.showError(
            "El precio ingresado no puede ser mayor al precio original o de descuento");
        return;
      }
    } catch (e) {
      EasyLoading.showError("Debe ingresar un precio válido");
      return;
    }

    FirebaseFS.modifyStoreOffer(
        finalPick,
        offerId,
        productId,
        priceController.text.isEmpty ? null : int.parse(priceController.text),
        selected);

    EasyLoading.showSuccess("Oferta modificada con éxito");

    // HACER POP
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      priceController.text = price.toString();
      selected = active;
      init = false;
    }
    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    Future<DateTime?> pickDateTime() async {
      DateTime? date = await pickDate();
      if (date == null) return null;

      TimeOfDay? time = await pickTime();
      if (time == null) return null;

      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text("Editar oferta de $name"),
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 20, right: 20),
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            imageURL,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                name,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Q$price.00',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Q$price_.00',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              Text(
                                '$quantity unidades',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Inicio de la Oferta: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${start.toDate().day}/${start.toDate().month}/${start.toDate().year} ${start.toDate().hour.toString().padLeft(2, '0')}:${start.toDate().minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Fin de la Oferta:",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final dateTime = await pickDateTime();
                                    if (dateTime == null) return;

                                    setState(() {
                                      finalPick = dateTime;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return Colors.green;
                                      },
                                    ),
                                  ),
                                  child: Text(
                                    '${finalPick.day}/${finalPick.month}/${finalPick.year} ${finalPick.hour.toString().padLeft(2, '0')}:${finalPick.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  controller: priceController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Nuevo Precio",
                                    hintStyle: const TextStyle(
                                      color: Color(0xffA6B0BD),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: const Icon(
                                      Icons.price_check,
                                      color: Colors.black,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Activa:",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black)),
                                Checkbox(
                                  value: selected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selected = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: ingresarOferta,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.green;
                          },
                        ),
                      ),
                      child: const Text(
                        "Modificar oferta",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )))));
  }
}
