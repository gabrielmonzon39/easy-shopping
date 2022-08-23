import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class FamilySection extends StatelessWidget {
  final controllerKey = TextEditingController();

  FamilySection({Key? key}) : super(key: key);

  Future<bool> getData() async {
    bool valid = await FirebaseFS.isAssociatedUser(uid!);
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Familia y Amigos"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Los familiares o amigos que se encuentran asociados a su casa son:",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 50,
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ////////////////////////////////////////////////////////////////
                      FutureBuilder<bool>(
                          future: getData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (!snapshot.hasData) {
                              // not loaded
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // some error
                              return Column(children: const [
                                Text(
                                  "Lo sentimos, ha ocurrido un error",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                Icon(
                                  Icons.close,
                                  size: 100,
                                ),
                              ]);
                            } else {
                              // loaded
                              bool? valid = snapshot.data;
                              if (valid!) {
                                return Column(children: const [
                                  Text("Sí hay datos"),
                                  Icon(Icons.check),
                                ]);
                              }
                            }
                            return Center(
                                child: Column(children: const [
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                "¡Ups! Parece que no se encuentra registrado. Vaya a la sección de Tokens para registrarse y continuar usando nuestros servicios.",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Icon(
                                Icons.sentiment_very_dissatisfied,
                                size: 100,
                              ),
                            ]));
                          }),
                      ////////////////////////////////////////////////////////////////
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ));
  }
}
