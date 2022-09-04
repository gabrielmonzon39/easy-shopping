import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddProductsSection extends StatefulWidget {
  const AddProductsSection({Key? key}) : super(key: key);
  @override
  AddProductsBuilder createState() => AddProductsBuilder();
}

class AddProductsBuilder extends State<AddProductsSection> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  String selected = types[types.length - 1];
  UploadTask? task;
  File? file;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  Widget uploadStatus(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final porcentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$porcentage%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            );
          }
          return Container();
        });
  }

  Future<void> uploadProduct() async {
    // check if it is valid data
    if (nameController.text == "" ||
        descriptionController.text == "" ||
        priceController.text == "" ||
        quantityController.text == "") return;
    if (file == null) return;
    final filePath = file!.path;
    final fileList = filePath.split("/");
    final fileName = fileList[fileList.length - 1];

    if (!fileName.contains("jpeg") &&
        !fileName.contains("jpg") &&
        !fileName.contains("png")) return;

    String storeId = await FirebaseFS.getStoreId(uid!);
    DocumentSnapshot? storeDetails = await FirebaseFS.getStoreDetails(storeId);
    if (storeDetails == null) return;

    String projectId = storeDetails.get('project_id');

    final destination = '$projectId/$storeId/$fileName';
    final uploadTask = uploadFile(destination, file!);
    if (uploadTask == null) return;

    setState(() {
      task = uploadTask;
    });

    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    FirebaseFS.addProduct(
        storeId,
        nameController.text,
        descriptionController.text,
        priceController.text,
        quantityController.text,
        urlDownload,
        selected);

    cleanData();

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("¡Producto agregado con éxito!"),
              content: const Text(
                  "Puede ver sus productos en el apartado 'Mis productos'."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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

  void cleanData() {
    nameController.text = "";
    descriptionController.text = "";
    priceController.text = "";
    quantityController.text = "";
    setState(() {
      file = null;
      task = null;
    });
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
    final filePath = file != null ? file!.path : "";
    final fileList = filePath.split("/");
    final fileName = fileList[fileList.length - 1];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Ingresar productos"),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        ////////////////////////////////////////////////////////////////////////////////////
                        Expanded(
                            child: Column(
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
                              decoration: const InputDecoration(
                                hintText: "Nombre del producto",
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
                              height: 35,
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
                              decoration: const InputDecoration(
                                hintText: "Descripción del producto",
                                hintStyle: TextStyle(
                                  color: Color(0xffA6B0BD),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.edit,
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
                              height: 35,
                            ),
                            Row(
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
                                  decoration: const InputDecoration(
                                    hintText: "Precio",
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
                                )),
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
                                    decoration: const InputDecoration(
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
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  "Tipo de producto: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownButton(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  value: selected,
                                  iconEnabledColor: secondaryColor,
                                  // Array list of items
                                  items: types.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selected = newValue!;
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
                      height: 35,
                    ),
                    ElevatedButton(
                      onPressed: selectFile,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return secondaryColor;
                          },
                        ),
                      ),
                      child: const Text(
                        "Subir imagen",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (file != null)
                      Text(
                        fileName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    const SizedBox(
                      height: 45,
                    ),
                    ElevatedButton(
                      onPressed: uploadProduct,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.green;
                          },
                        ),
                      ),
                      child: const Text(
                        "Ingresar producto",
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
                    if (task != null) uploadStatus(task!),
                  ],
                )))));
  }
}
