import 'dart:io';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/show_image_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SettingsSection extends StatefulWidget {
  final String projectId;
  const SettingsSection({Key? key, required this.projectId}) : super(key: key);
  @override
  SettingsSectionBuilder createState() => SettingsSectionBuilder();
}

class SettingsSectionBuilder extends State<SettingsSection> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? filePath;
  String? fileName;

  Future<void> generateStore() async {
    String storeId = await FirebaseFS.getStoreId(uid!);

    if (nameController.text != "") {
      FirebaseFS.setStoreName(storeId, nameController.text.trim());
    }

    if (descriptionController.text != "") {
      FirebaseFS.setStoreDescription(
          storeId, descriptionController.text.trim());
    }

    if (file != null) {
      String projectId = widget.projectId;
      /*String storeId = await FirebaseFS.generateStore(
        nameController.text, descriptionController.text, projectId);*/

      print("File NAME --->  $fileName");

      if (!fileName!.contains("jpeg") &&
          !fileName!.contains("jpg") &&
          !fileName!.contains("png")) return;

      final destination = '$projectId/$storeId/$fileName';
      final uploadTask = uploadFile(destination, file!);
      if (uploadTask == null) return;

      setState(() {
        task = uploadTask;
      });

      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      await FirebaseFS.setStoreImage(storeId, urlDownload);
    }

    if (file == null &&
        nameController.text == "" &&
        descriptionController.text == "") {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Parece que no hay nada por guardar."),
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
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("¡Cambios guardados con éxito!"),
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

    cleanData();
  }

  void cleanData() {
    nameController.text = "";
    descriptionController.text = "";
    file = null;
    task = null;
    setState(() {});
  }

  File? file;
  UploadTask? task;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
      filePath = file!.path;
      final fileList = filePath!.split("/");
      fileName = fileList[fileList.length - 1];
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
          title: const Text("Configuración"),
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
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Nuevo nombre",
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
                              controller: descriptionController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Nueva descripción",
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
                              ShowImageButton(
                                imagePath: filePath,
                                imageName: fileName,
                                buttonColor: secondaryColor,
                              ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: generateStore,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.green;
                          },
                        ),
                      ),
                      child: const Text(
                        "Guardar cambios",
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
