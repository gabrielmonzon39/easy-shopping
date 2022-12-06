import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class PublicitySection extends StatefulWidget {
  const PublicitySection({Key? key}) : super(key: key);
  @override
  PublicitySectionBuilder createState() => PublicitySectionBuilder();
}

class PublicitySectionBuilder extends State<PublicitySection> {
  int count = 0;
  bool success = true;

  Future<void> savePublicity() async {
    String storeId = await FirebaseFS.getStoreId(uid!);
    if (await FirebaseFS.hasPublicity(storeId)) {
      success = false;
    } else {
      FirebaseFS.addPublicity(storeId, count, DateTime.now());
    }
    showAlert();
  }

  void showAlert() {
    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("¡Su solicitud ha sido procesada!"),
          content: Text(
              "Dirigase a adminsitración y pague Q${count * publicityPrice}.00. Le enviaremos una notificación cuando su solicitud haya sido aprobada."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // MODALERT
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
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Ha ocurrido un error."),
          content: const Text(
              "Parece que ya tiene una solicitud, espere a que se termine para solicitar otra."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // MODALERT
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Publicidad"),
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
                  const Text(
                    "¿Cuántos días desea de publicidad?",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return primaryColor;
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            count--;
                            if (count < 0) {
                              count = 0;
                            }
                          });
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        count.toString(),
                        style:
                            const TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return primaryColor;
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            count++;
                          });
                        },
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Q${count * publicityPrice}.00",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.green;
                          },
                        ),
                      ),
                      onPressed: () async {
                        savePublicity();
                      },
                      child: const Text("Aceptar"),
                    ),
                  ),
                ],
              ),
            )));
  }
}
