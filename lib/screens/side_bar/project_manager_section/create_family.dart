import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';

class CreateFamilySection extends StatefulWidget {
  final String projectId;
  const CreateFamilySection({Key? key, required this.projectId})
      : super(key: key);
  @override
  CreateFamilyBuilder createState() => CreateFamilyBuilder();
}

class CreateFamilyBuilder extends State<CreateFamilySection> {
  final addressController = TextEditingController();
  final quantityController = TextEditingController();

  String generatedToken = '';

  void cleanData() {
    addressController.text = "";
    quantityController.text = "";
    setState(() {});
  }

  Future<void> generateToken() async {
    generatedToken = await FirebaseFS.generateUsersToken(addressController.text,
        int.parse(quantityController.text), widget.projectId);
    setState(() {});
    cleanData();

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("¡Token generada con éxito!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // dismiss dialog
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(14),
                    child: const Text("Aceptar"),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 5000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 45.0
      ..radius = 50.0
      ..userInteractions = true
      ..dismissOnTap = true;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Generar Familia"),
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 20, right: 20),
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ////////////////////////////////////////////////////////////////////////////////////
                        Expanded(
                            child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              controller: addressController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Direccion",
                                hintStyle: TextStyle(
                                  color: Color(0xffA6B0BD),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.text_fields,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              controller: quantityController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Cantidad de personas en la familia",
                                hintStyle: TextStyle(
                                  color: Color(0xffA6B0BD),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.numbers_sharp,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: generateToken,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.green;
                          },
                        ),
                      ),
                      child: const Text(
                        "Generar Token",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: generatedToken == ''
                          ? []
                          : [
                              Text(
                                generatedToken,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy, color: secondaryColor),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: generatedToken));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Copiado al portapapeles')));
                                },
                              )
                            ],
                    ),
                  ],
                )))));
  }
}
