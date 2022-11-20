import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/publicity_request_view.dart';
import 'package:flutter/material.dart';

class ManagePublicitySection extends StatefulWidget {
  const ManagePublicitySection({Key? key}) : super(key: key);
  @override
  ManagePublicitySectionBuilder createState() =>
      ManagePublicitySectionBuilder();
}

class ManagePublicitySectionBuilder extends State<ManagePublicitySection> {
  DocumentSnapshot? details;
  List<Widget> list = [];
  Widget? result;

  Future<void> getStoreDetails(String storeId) async {}

  Future<bool> getRequests() async {
    QuerySnapshot pubCollection =
        await FirebaseFirestore.instance.collection('publicity').get();
    for (var document in pubCollection.docs) {
      if (document.get('state') == READY) {
        list.add(const SizedBox(
          width: 0,
          height: 0,
        ));
      }

      if (document.get('active')) {
        details = await FirebaseFS.getStoreDetails(document.id);
        if (details == null) print("UNUUUUUUUUU");
        list.add(PublicityRequestView(
            id: document.id,
            name: details!.get('name'),
            description: details!.get('description'),
            count: document.get('days'),
            imageURL: details!.get('image')));
      } else {
        FirebaseFS.inactiveRequest(document.id);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Administrar solicitudes"),
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
                  /*Expanded(
                    child:
                        ////////////////////////////////////////////////////////////////
                        StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('publicity')
                          .snapshots(),
                      builder:
                          (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                        if (usersnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: usersnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot<Object?>? document =
                                  usersnapshot.data?.docs[index];
                              try {
                                print(
                                    "000000000000000000000000000000000000000000000000000000000000000000000000000");
                                Timestamp stamp = document!.get('start');
                                DateTime start = stamp.toDate();
                                start.add(Duration(days: document.get('days')));

                                if (document.get('state') == READY) {
                                  return const SizedBox(
                                    width: 0,
                                    height: 0,
                                  );
                                }

                                if (document.get('active')) {
                                  getStoreDetails(document.id);
                                  if (details == null) print("UNUUUUUUUUU");
                                  return PublicityRequestView(
                                      id: document.id,
                                      name: details!.get('name'),
                                      description: details!.get('description'),
                                      count: document.get('days'),
                                      imageURL: details!.get('image'));
                                } else {
                                  FirebaseFS.inactiveRequest(document.id);
                                }
                              } catch (e) {
                                print(e.toString());
                              }
                              return const SizedBox(
                                width: 0,
                                height: 0,
                              );
                            },
                          );
                        }
                      },
                    ),
                    ////////////////////////////////////////////////////////////////
                  ),*/
                ],
              ),
            )));
  }
}
