import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);
  @override
  UserBuilder createState() => UserBuilder();
}

class UserBuilder extends State<UserMainScreen> {
  final nameController = TextEditingController();
  final maxViewController = TextEditingController();
  final defaultMaxView = 10;
  int currentMaxView = 0;
  int count = 0;

  bool selected = true;
  String selectedOption = types[types.length - 1];

  UserBuilder() {
    currentMaxView = defaultMaxView;
  }

  bool evalConditions(QueryDocumentSnapshot<Object?>? document) {
    if (document == null) return false;
    if (document.id == "8NSZ1ielRBQyriNRwXdx") return false;
    if (document.get('quantity') == 0) return false;

    count++;
    if (count > int.parse(maxViewController.text)) return false;

    if (selected) {
      return nameCondition(document);
    } else {
      String fireBaseType = typesFB[types.indexOf(selectedOption)];
      if (document.get('type') != fireBaseType) return false;
      return nameCondition(document);
    }
  }

  bool nameCondition(QueryDocumentSnapshot<Object?>? document) {
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
    maxViewController.text = currentMaxView.toString();
    return SizedBox(
        height: 680,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextField(
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
                    setState(() {
                      if (maxViewController.text == "") {
                        maxViewController.text = defaultMaxView.toString();
                      }
                      currentMaxView = int.parse(maxViewController.text);
                      count = 0;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Vista máxima: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  )),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: maxViewController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Color(0xffA6B0BD),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.format_list_bulleted,
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Todo:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  )),
              Checkbox(
                value: selected,
                onChanged: (bool? value) {
                  setState(() {
                    selected = value!;
                  });
                },
              ),
              if (!selected)
                DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  value: selectedOption,
                  iconEnabledColor: secondaryColor,
                  // Array list of items
                  items: types.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
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
                        if (evalConditions(document)) {
                          return Column(
                            children: [
                              ProductView(
                                id: document!.id,
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
            ),
          ),
        ]));
  }
}
