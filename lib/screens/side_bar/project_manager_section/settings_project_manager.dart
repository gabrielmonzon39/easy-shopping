import 'dart:io';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/colors.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/show_image_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsPMSection extends StatefulWidget {
  const SettingsPMSection({Key? key}) : super(key: key);
  @override
  SettingsPMSectionBuilder createState() => SettingsPMSectionBuilder();
}

class SettingsPMSectionBuilder extends State<SettingsPMSection> {
  final nameController = TextEditingController();
  String? filePath;
  String? fileName;

  Color localPrimaryColor = primaryColor;
  Color localSecondaryColor = secondaryColor;
  Color localTernaryColor = ternaryColor;

  Color? newPrimaryColor;
  Color? newSecondaryColor;
  Color? newTernaryColor;

  Future<void> changeColorsAndImage() async {
    String projectId = await FirebaseFS.getProjectIdForProjectManager(uid!);
    if (file != null) {
      if (!fileName!.contains("jpeg") &&
          !fileName!.contains("jpg") &&
          !fileName!.contains("png")) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title:
                      const Text("Ha ocurrido un error al guardar los datos."),
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
        return;
      }

      final destination = '$projectId/$fileName';
      final uploadTask = uploadFile(destination, file!);
      if (uploadTask == null) return;

      setState(() {
        task = uploadTask;
      });

      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      await FirebaseFS.setProjectImage(projectId, urlDownload);
    }

    await FirebaseFS.setProjectColors(projectId, localPrimaryColor.value,
        localSecondaryColor.value, localTernaryColor.value);
    //await getAndSetColors();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                  "¡Cambios guardados con éxito! Reinicie la aplicación para ver los cambios reflejados."),
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

    cleanData();
  }

  void cleanData() {
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
                        ////////////////////////////////////////////////////////////////////////////////////
                        Expanded(
                            child: Column(
                          children: [
                            // PRIMARY COLOR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Color primario       ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: localPrimaryColor),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return localPrimaryColor;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Color primario"),
                                        content: ColorPicker(
                                          pickerColor:
                                              localPrimaryColor, //default color
                                          onColorChanged: (Color color) {
                                            //on color picked
                                            newPrimaryColor = color;
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("Cancelar"),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                              if (newPrimaryColor != null) {
                                                localPrimaryColor =
                                                    newPrimaryColor!;
                                              }
                                              setState(() {});
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
                                  child: const Text(""),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // SEECONDARY COLOR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Color secundario  ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: localSecondaryColor),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return localSecondaryColor;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Color secundario"),
                                        content: ColorPicker(
                                          pickerColor:
                                              localSecondaryColor, //default color
                                          onColorChanged: (Color color) {
                                            //on color picked
                                            newSecondaryColor = color;
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("Cancelar"),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                              if (newSecondaryColor != null) {
                                                localSecondaryColor =
                                                    newSecondaryColor!;
                                              }
                                              setState(() {});
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
                                  child: const Text(""),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // TERNARY COLOR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Color alterno         ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: localTernaryColor),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return localTernaryColor;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Color alterno"),
                                        content: ColorPicker(
                                          pickerColor:
                                              localTernaryColor, //default color
                                          onColorChanged: (Color color) {
                                            //on color picked
                                            newTernaryColor = color;
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("Cancelar"),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                              if (newTernaryColor != null) {
                                                localTernaryColor =
                                                    newTernaryColor!;
                                              }
                                              setState(() {});
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
                                  child: const Text(""),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
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
                                hintText: "Nombre del producto",
                                hintStyle: const TextStyle(
                                  color: Color(0xffA6B0BD),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.description,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
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
                                "Cambiar logo",
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
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: changeColorsAndImage,
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
