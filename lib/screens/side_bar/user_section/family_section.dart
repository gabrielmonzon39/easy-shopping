// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/material.dart';

class FamilySection extends StatelessWidget {
  const FamilySection({Key? key}) : super(key: key);

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
                Text(
                  "Casa: $homeId",
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////////
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
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
                                if (document!.get('home_id') == homeId) {
                                  return Card(
                                    color: Colors.amber[50],
                                    margin: const EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.pink[50],
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.face,
                                          size: 50,
                                        ),
                                        title: Text(
                                          document.get('name'),
                                          style: const TextStyle(
                                              fontSize: 19,
                                              color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          document.get('email'),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {}
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
