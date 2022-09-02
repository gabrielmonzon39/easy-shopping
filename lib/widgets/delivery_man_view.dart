// ignore_for_file: must_be_immutable, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryManView extends StatelessWidget {
  String? deliveryManId;

  DeliveryManView({Key? key, @required this.deliveryManId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////////
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
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
                    if (document!.get('delivery_man_id') == deliveryManId) {
                      return Card(
                        color: Colors.amber[50],
                        margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 5,
                        shadowColor: Colors.pink[50],
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          child: ListTile(
                            leading: const Icon(
                              Icons.face,
                              size: 50,
                            ),
                            title: Text(
                              document.get('name'),
                              style: const TextStyle(
                                  fontSize: 19, color: Colors.black),
                            ),
                            subtitle: Text(
                              document.get('email'),
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black),
                            ),
                          ),
                        ),
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
    );
  }
}
