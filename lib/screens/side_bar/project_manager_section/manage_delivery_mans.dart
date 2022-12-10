import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/delivery_man_view.dart';
import 'package:easy_shopping/widgets/publicity_request_view.dart';
import 'package:flutter/material.dart';

class ManageDeliverMansSection extends StatefulWidget {
  const ManageDeliverMansSection({Key? key}) : super(key: key);
  @override
  ManageDeliverMansBuilder createState() => ManageDeliverMansBuilder();
}

class ManageDeliverMansBuilder extends State<ManageDeliverMansSection> {
  DocumentSnapshot? details;
  List<Widget> list = [];
  Widget? result;

  Widget deliveryManView(
      bool active, QueryDocumentSnapshot<Object?>? document) {
    String id = document!.get('delivery_man_id');
    String name = document.get('name');
    String email = document.get('email');
    String photo = document.get('photo');
    String creationTime = document.get('creationTime');
    String lastSignInTime = document.get('lastSignInTime');
    String status = active ? 'Activo(a)' : 'Inactivo(a)';
    Color color = active ? Colors.green : Colors.red;
    return ElevatedButton(
        onPressed: () async {
          await FirebaseFS.changeDeliveryManStatus(id, !active);
          setState(() {});
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return color;
            },
          ),
        ),
        child: Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Image.network(
                          photo,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 8, bottom: 8),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    email,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Fecha de ingreso: ${creationTime.split(" ")[0]}',
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    'Último inicio de sesión: ${lastSignInTime.split(" ")[0]}',
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ])));
  }

  Future<bool> getRequests() async {
    String projectId = await FirebaseFS.getProjectIdForProjectManager(uid!);

    QuerySnapshot delManCollection = await FirebaseFirestore.instance
        .collection('delivery_mans')
        .where('project_id', isEqualTo: projectId)
        .get();

    for (final document in delManCollection.docs) {
      bool active = document.get('active');

      QuerySnapshot delManDetails = await FirebaseFirestore.instance
          .collection('users')
          .where('delivery_man_id', isEqualTo: document.id)
          .get();

      for (final document2 in delManDetails.docs) {
        list.add(deliveryManView(active, document2));
      }

      list.add(const SizedBox(
        height: 10,
      ));
    }

    result = Column(
      children: list,
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    list = [];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Administrar Repartidores"),
        ),
        body: Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
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
                  Expanded(
                      child: SingleChildScrollView(
                    child: FutureBuilder<bool>(
                        future: getRequests(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (!snapshot.hasData) {
                            // not loaded
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
                              return result!;
                            }
                          }
                          return Center(
                              child: Column(children: const [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "¡Ups! Ha ocurrido un error al obtener los datos.",
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
                  )),
                ],
              ),
            )));
  }
}
