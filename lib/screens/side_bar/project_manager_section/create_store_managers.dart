import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';

class CreateStoreManagersSection extends StatefulWidget {
  final String projectId;

  const CreateStoreManagersSection({Key? key, required this.projectId})
      : super(key: key);
  @override
  CreateStoreManagersBuilder createState() => CreateStoreManagersBuilder();
}

class CreateStoreManagersBuilder extends State<CreateStoreManagersSection> {
  final nameController = TextEditingController();

  String selected = types[types.length - 1];
  UploadTask? task;
  File? file;

  String? selectedStore;
  String generatedToken = '';

  void cleanData() {
    nameController.text = "";
    selectedStore = null;
    setState(() {
      file = null;
      task = null;
    });
  }

  Future<void> generateToken() async {
    generatedToken = await FirebaseFS.generateStoreManagerToken(selectedStore!);
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
    Stream<QuerySnapshot<Object?>> stores =
        FirebaseFS.getProjectStores(widget.projectId, uid);

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
          title: const Text("Generar Store Manager"),
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
                        ////////////////////////////////////////////////////////////////////////////////////
                        Expanded(
                            child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: stores,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return DropdownButton(
                                    value: selectedStore,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    hint: const Text("Tiendas"),
                                    // Array list of items
                                    items: snapshot.data?.docs.map((project) {
                                      return DropdownMenuItem(
                                        value: project.id,
                                        child: Text(project['name']),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          selectedStore = value!;
                                        },
                                      );
                                    },
                                  );
                                }),
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
                                icon: const Icon(Icons.copy,
                                    color: secondaryColor),
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
