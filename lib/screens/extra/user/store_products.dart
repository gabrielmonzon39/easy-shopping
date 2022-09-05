// ignore_for_file: empty_catches, must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class StoreProduct extends StatefulWidget {
  String? storeId;
  String? name;
  int? color;

  StoreProduct(
      {Key? key,
      @required this.storeId,
      @required this.name,
      @required this.color})
      : super(key: key);
  @override
  StoreProductBuilder createState() =>
      StoreProductBuilder(storeId: storeId, name: name, color: color);
}

class StoreProductBuilder extends State<StoreProduct> {
  String? storeId;
  String? name;
  int? color;
  bool availableRefresh = true;
  final nameController = TextEditingController();

  StoreProductBuilder(
      {@required this.storeId, @required this.name, @required this.color});

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text(name!),
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
                    child: ////////////////////////////////////////////////////////////////
                        StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
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
                            if (document!.get('store_id') == storeId! &&
                                document.get('quantity') != 0 &&
                                evalConditions(document)) {
                              return Column(
                                children: [
                                  ProductView(
                                    id: document.id,
                                    name: document.get('name'),
                                    description: document.get('description'),
                                    price: document.get('price').toString(),
                                    quantity:
                                        document.get('quantity').toString(),
                                    imageURL: document.get('image'),
                                    isUser: true,
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
                )
                    ////////////////////////////////////////////////////////////////
                    ),
              ],
            ),
          ),
        ));
  }
}
