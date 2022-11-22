import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Emitir Comunicado"),
        ),
        body: Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 20, bottom: 20, left: 0, right: 0),
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SizedBox(
              height: 680,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ////////////////////////////////////////////////////////////////
                  SizedBox(
                    width: 290,
                    child: TextField(
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 290,
                    height: 300,
                    child: TextField(
                      keyboardType: TextInputType.text,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.green;
                        },
                      ),
                    ),
                    onPressed: () async {
                      FirebaseFS.addNew(
                          await FirebaseFS.getProjectIdForProjectManager(uid),
                          titleController.text,
                          bodyController.text);
                      sendNotifications(
                          USER, titleController.text, bodyController.text, "");
                      sendNotifications(STORE_MANAGER, titleController.text,
                          bodyController.text, "");
                      sendNotifications(DELIVERY_MAN, titleController.text,
                          bodyController.text, "");
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Comunicado enviado con éxito."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop(true);
                                Navigator.pop(context, true);
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
                      titleController.clear();
                      bodyController.clear();
                    },
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
                ],
              ),
            )));
  }
}
