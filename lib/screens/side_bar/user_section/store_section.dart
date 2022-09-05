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
  final nameController = TextEditingController();

  Future<void> calculateProjectId() async {
    final projectId = await FirebaseFS.getProjectId(uid!);
    availableRefresh = false;
    setState(() {
      id = projectId;
    });
  }

  bool evalConditions(QueryDocumentSnapshot<Object?>? document) {
    if (nameController.text == "") return true;
    if (!document!
        .get('name')
        .toString()
        .toLowerCase()
        .contains(nameController.text.toLowerCase())) {
      return false;
    }
    return true;
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
          child: SizedBox(
            height: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        controller: nameController,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Nombre de la tienda",
                          hintStyle: TextStyle(
                            color: Color(0xffA6B0BD),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.description,
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
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.green;
                            },
                          ),
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child:
                        ////////////////////////////////////////////////////////////////
                        StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stores')
                      .snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                    if (usersnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: usersnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Object?>? document =
                              usersnapshot.data?.docs[index];
                          try {
                            if (document!.get('project_id') == id! &&
                                evalConditions(document)) {
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
                )),
                ////////////////////////////////////////////////////////////////
              ],
            ),
          ),
        ));
  }
}
