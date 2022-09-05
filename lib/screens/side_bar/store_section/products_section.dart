// ignore_for_file: empty_catches, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({Key? key}) : super(key: key);
  @override
  ProductsSectionBuilder createState() => ProductsSectionBuilder();
}

class ProductsSectionBuilder extends State<ProductsSection> {
  String? id;
  int? color;
  bool availableRefresh = true;
  final nameController = TextEditingController();

  Future<void> calculateStoreId() async {
    final storeId = await FirebaseFS.getStoreId(uid!);
    availableRefresh = false;
    color = await FirebaseFS.getColorStore(storeId);
    setState(() {
      id = storeId;
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
    if (availableRefresh) calculateStoreId();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Mis productos"),
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
                            hintText: "Nombre del producto",
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
                        width: 30,
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
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
                                if (document!.get('store_id') == id! &&
                                    evalConditions(document)) {
                                  return Column(
                                    children: [
                                      ProductView(
                                        id: document.id,
                                        name: document.get('name'),
                                        description:
                                            document.get('description'),
                                        price: document.get('price').toString(),
                                        quantity:
                                            document.get('quantity').toString(),
                                        imageURL: document.get('image'),
                                        isUser: false,
                                      ),
                                      const SizedBox(
                                        height: 20,
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
                    ),
                  ),
                ],
              ),
            )));
  }
}
