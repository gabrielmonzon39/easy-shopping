// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/side_bar/project_manager_section/manage_publicity.dart';
import 'package:flutter/material.dart';

class PublicityRequestView extends StatelessWidget {
  String? id;
  String? name;
  String? description;
  int? count;
  String? imageURL;

  final limitDescriptionSize = 25;

  PublicityRequestView({
    Key? key,
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.count,
    @required this.imageURL,
  }) : super(key: key);

  void manageDescription() {
    if (description!.length > limitDescriptionSize) {
      description = description!.substring(0, limitDescriptionSize);
      description = "${description!}...";
    }
  }

  @override
  Widget build(BuildContext context) {
    manageDescription();
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageURL!,
                height: 100,
                width: 100,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        description!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Días: ${count!.toString()}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        "Q${count! * publicityPrice}.00",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Aprobar solicitud"),
                          content: Text(
                              "Se aprobará la solicitud de publicidad de $name por $count días."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                await FirebaseFS.updatePublicityRequest(id!);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ManagePublicitySection(),
                                    ));
                              },
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(14),
                                child: const Text("Aprobar"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return const Color.fromARGB(255, 156, 146, 48);
                        },
                      ),
                    ),
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      BuildContext dialogContext;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            dialogContext = context;
                            return AlertDialog(
                              title: const Text("Cancelar solicitud"),
                              content: Text(
                                  "¿Desea cancelar la solicitud de publicidad de $name?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFS.deletePublicityRequest(
                                        id!);
                                    Navigator.pop(dialogContext);
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("Cancelar"),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.red;
                        },
                      ),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
