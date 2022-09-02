import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);
  @override
  UserBuilder createState() => UserBuilder();
}

class UserBuilder extends State<UserMainScreen> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
        keyboardType: TextInputType.text,
        obscureText: false,
        controller: nameController,
        style: const TextStyle(
          fontSize: 16,
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
            Icons.search,
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
      const SizedBox(
        height: 15,
      ),
      Center(
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.green;
              },
            ),
          ),
          child: const Text(
            "Buscar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
                            print("Fucooooo");
                            if (document!.id != "8NSZ1ielRBQyriNRwXdx" &&
                                document.get('quantity') != 0) {
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
    ]));
  }
}
