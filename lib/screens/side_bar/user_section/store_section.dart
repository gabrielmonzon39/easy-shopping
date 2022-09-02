// ignore_for_file: empty_catches, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/store_service_view.dart';
import 'package:flutter/material.dart';

class StoresSection extends StatefulWidget {
  const StoresSection({Key? key}) : super(key: key);
  @override
  StoresSectionBuilder createState() => StoresSectionBuilder();
}

class StoresSectionBuilder extends State<StoresSection> {
  String? id;
  bool availableRefresh = true;

  Future<void> calculateProjectId() async {
    final projectId = await FirebaseFS.getProjectId(uid!);
    availableRefresh = false;
    setState(() {
      id = projectId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (availableRefresh) calculateProjectId();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Tiendas"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
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
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////////
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('stores')
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
                                if (document!.get('project_id') == id!) {
                                  return StoreServiceView(
                                    name: document.get('name'),
                                    description: document.get('description'),
                                    imageURL: document.get('image'),
                                    storeId: document.id,
                                    color: document.get('color'),
                                  );
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
                    )
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
                const SizedBox(
                  height: 500,
                ),
              ],
            ),
          ),
        ));
  }
}
