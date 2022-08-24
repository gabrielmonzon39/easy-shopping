import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StoreManagerMainScreen extends StatefulWidget {
  const StoreManagerMainScreen({Key? key}) : super(key: key);
  @override
  StoreManagerBuilder createState() => StoreManagerBuilder();
}

class StoreManagerBuilder extends State<StoreManagerMainScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
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
    if (nameController.text == "" &&
        descriptionController.text == "" &&
        priceController.text == "" &&
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
        urlDownload);

    cleanData();
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
    final filePath = file != null ? file!.path : "";
    final fileList = filePath.split("/");
    final fileName = fileList[fileList.length - 1];
    return Column(
      children: [
        const Center(
          child: Text(
            "Ingreso de productos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
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
                          borderSide: BorderSide(color: secondaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(200),
                          ),
                          borderSide: BorderSide(color: secondaryColor),
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
                    )
                  ],
                )
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
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
    );
  }
}
