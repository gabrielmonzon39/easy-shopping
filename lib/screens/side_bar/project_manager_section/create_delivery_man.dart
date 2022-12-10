import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';

class CreateDeliveryManSection extends StatefulWidget {
  final String projectId;
  const CreateDeliveryManSection({Key? key, required this.projectId})
      : super(key: key);
  @override
  CreateDeliveryManBuilder createState() => CreateDeliveryManBuilder();
}

class CreateDeliveryManBuilder extends State<CreateDeliveryManSection> {
  String generatedToken = '';

  Future<void> generateToken() async {
    generatedToken =
        await FirebaseFS.generateDeliveryManToken(widget.projectId);
    setState(() {});

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
          title: const Text("Generar Repartidor"),
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
