import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddOffersSection extends StatefulWidget {
  final String storeId;
  const AddOffersSection({Key? key, required this.storeId}) : super(key: key);
  @override
  AddOffersBuilder createState() => AddOffersBuilder();
}

class AddOffersBuilder extends State<AddOffersSection> {
  final priceController = TextEditingController();
  String? selectedProductId;
  int? selectedProductPrice;
  Map<String, int> productPrices = {};
  String selected = offerTypes[0];

  DateTime initialPick = DateTime.now();
  DateTime finalPick = DateTime.now();

  void ingresarOferta() async {
    if (selectedProductId == null) {
      EasyLoading.showError("Debe de seleccionar un producto");
      return;
    }

    if (initialPick.isAfter(finalPick) ||
        initialPick.isAtSameMomentAs(finalPick)) {
      EasyLoading.showError(
          "La fecha y hora de inicio no puede ser mayor o igual a la final");
      return;
    }

    if (selected == "Rebaja de precio" && priceController.text == "") {
      EasyLoading.showError("Debe de ingresar un precio");
      return;
    }

    if (selected == "Rebaja de precio" &&
        int.parse(priceController.text) > selectedProductPrice!) {
      EasyLoading.showError(
          "El precio ingresado no puede ser mayor al precio original");
      return;
    }

    FirebaseFS.addStoreOffer(
        initialPick,
        finalPick,
        widget.storeId,
        selected,
        selectedProductId!,
        priceController.text.isEmpty ? null : int.parse(priceController.text));

    sendNotifications(
        USER,
        selected,
        "Aprovecha esta gran oferta por tiempo limitado. Entra para ver más detalles.",
        await FirebaseFS.getImageOfProduct(selectedProductId!));
    EasyLoading.showSuccess("Oferta agregada con éxito");
    cleanData();
  }

  void cleanData() {
    priceController.text = "";
    selectedProductId = null;
    selectedProductPrice = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>> storeProducts =
        FirebaseFS.getStoreProducts(widget.storeId);

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
          title: const Text("Agregar ofertas"),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Producto a ofertar:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: storeProducts,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      return DropdownButton(
                                        value: selectedProductId,
                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        hint: const Text("Productos"),
                                        // Array list of items
                                        items:
                                            snapshot.data?.docs.map((product) {
                                          productPrices.addEntries([
                                            MapEntry(product.id,
                                                product.get("price").toInt())
                                          ]);
                                          return DropdownMenuItem(
                                            value: product.id,
                                            child: Text(product['name'] +
                                                " - Q" +
                                                product['price'].toString()),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(
                                            () {
                                              selectedProductId = value!;
                                              selectedProductPrice =
                                                  productPrices[
                                                      selectedProductId!];
                                            },
                                          );
                                        },
                                      );
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tipo de Oferta:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownButton(
                                  value: selected,
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: const Text("Tipo de oferta"),
                                  // Array list of items
                                  items: offerTypes.map((String type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(
                                      () {
                                        selected = value!;
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Inicio de la Oferta:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final dateTime = await pickDateTime();
                                    if (dateTime == null) return;

                                    setState(() {
                                      initialPick = dateTime;
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
                                      '${initialPick.day}/${initialPick.month}/${initialPick.year} ${initialPick.hour.toString().padLeft(2, '0')}:${initialPick.minute.toString().padLeft(2, '0')}'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Fin de la Oferta:",
                                  style: TextStyle(
                                    fontSize: 15,
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
                                      '${finalPick.day}/${finalPick.month}/${finalPick.year} ${finalPick.hour.toString().padLeft(2, '0')}:${finalPick.minute.toString().padLeft(2, '0')}'),
                                ),
                              ],
                            ),
                            if (selected == "Rebaja de precio")
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
                                      hintStyle: TextStyle(
                                        color: Color(0xffA6B0BD),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.price_check,
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
                                ],
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                      ],
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
                        "Ingresar oferta",
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
