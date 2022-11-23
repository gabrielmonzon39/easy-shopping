import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/notifications.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);
  @override
  UserBuilder createState() => UserBuilder();
}

class UserBuilder extends State<UserMainScreen> {
  final nameController = TextEditingController();
  bool valid = true;

  String selectedOption = types[types.length - 1];

  bool evalConditions(QueryDocumentSnapshot<Object?>? document) {
    if (document == null) return false;
    if (document.id == "8NSZ1ielRBQyriNRwXdx") return false;
    if (document.get('quantity') <= 0) return false;

    return true;
  }

  Future<void> checkProjectofProduct(
      QueryDocumentSnapshot<Object?>? document) async {
    valid = await FirebaseFS.checkProjectofProduct(document!.get('store_id'));
  }

  int count2 = 0;
  List<String> topProducts = [];
  Future<void> topUserProducts() async {
    if (count2 != 0) return;
    topProducts = await FirebaseFS.getTopUserProducts(uid!);
    count2++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    topUserProducts();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Object?>? document =
                  snapshot.data?.docs[index];
              try {
                if (evalConditions(document!) &&
                    topProducts.contains(document.id)) {
                  return Column(
                    children: [
                      ProductView(
                        id: document.id,
                        name: document.get('name'),
                        description: document.get('description'),
                        price: document.get('price').toString(),
                        quantity: document.get('quantity').toString(),
                        imageURL: document.get('image'),
                        isUser: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
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
    );
  }
}
