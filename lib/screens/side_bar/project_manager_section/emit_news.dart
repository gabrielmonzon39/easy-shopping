import 'dart:io';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/notifications.dart';
import 'package:easy_shopping/widgets/show_image_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EmitNewsSection extends StatefulWidget {
  const EmitNewsSection({Key? key}) : super(key: key);
  @override
  EmitNewsSectionSectionBuilder createState() =>
      EmitNewsSectionSectionBuilder();
}

class EmitNewsSectionSectionBuilder extends State<EmitNewsSection> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
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
              'Completado al: $porcentage%',
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

  Future<void> uploadNew() async {
    // check if it is valid data
    if (titleController.text == "" || bodyController.text == "") return;
    if (file == null) return;

    final filePath = file!.path;
    final fileList = filePath.split("/");
    final fileName = fileList[fileList.length - 1];

    if (!fileName.contains("jpeg") &&
        !fileName.contains("jpg") &&
        !fileName.contains("png")) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Ha ocurrido un error al guardar los datos."),
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

    final projectId = await FirebaseFS.getProjectIdForProjectManager(uid);
    final destination = '$projectId/news/images/$fileName';
    final uploadTask = uploadFile(destination, file!);
    if (uploadTask == null) return;

    setState(() {
      task = uploadTask;
    });

    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    FirebaseFS.addNew(await FirebaseFS.getProjectIdForProjectManager(uid),
        titleController.text, bodyController.text, urlDownload);

    // SEND NOTIFICATIONS
    sendNotifications(USER, titleController.text, bodyController.text, "");
    sendNotifications(
        STORE_MANAGER, titleController.text, bodyController.text, "");
    sendNotifications(
        DELIVERY_MAN, titleController.text, bodyController.text, "");

    // SHOW ALERT
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Comunicado enviado con éxito."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
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

    cleanData();
  }

  void cleanData() {
    titleController.text = "";
    bodyController.text = "";
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Emitir Comunicado"),
        ),
        body: SafeArea(
          child: Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.only(top: 20, bottom: 20, left: 0, right: 0),
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ////////////////////////////////////////////////////////////////
                    TextField(
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      controller: titleController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Título",
                        hintStyle: const TextStyle(
                          color: Color(0xffA6B0BD),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.article,
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
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      obscureText: false,
                      controller: bodyController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Descripción",
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
                      height: 40,
                    ),
                    ////////////////////////////////////////////////////////////
                    Center(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                            if (file != null)
                              ShowImageButton(
                                imagePath: filePath,
                                imageName: fileName,
                                buttonColor: secondaryColor,
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.green;
                              },
                            ),
                          ),
                          onPressed: uploadNew,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(Icons.send),
                                Text(
                                  "Enviar",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (task != null) uploadStatus(task!),
                      ]),
                    ),
                  ],
                ),
              )),
        ));
  }
}
