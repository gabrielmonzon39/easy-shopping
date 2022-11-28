import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/side_bar/nav_bar.dart';
import 'package:easy_shopping/widgets/product_view.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  @override
  SearchBuilder createState() => SearchBuilder();
}

class SearchBuilder extends State<Search> {
  final nameController = TextEditingController();
  final maxViewController = TextEditingController();
  final defaultMaxView = 10;

  int currentMaxView = 0;
  int count = 0;

  bool first = true;
  bool valid = true;

  List<String> stores = [];

  bool selected = false;
  String selectedOption = types[types.length - 1];

  SearchBuilder() {
    currentMaxView = 0;
  }

  bool evalConditions(QueryDocumentSnapshot<Object?>? document) {
    if (document == null) return false;
    if (document.id == "8NSZ1ielRBQyriNRwXdx") return false;
    if (document.get('quantity') <= 0) return false;
    if (document.get('visible') == false) return false;

    count++;
    if (count > int.parse(maxViewController.text)) return false;
    //print(count);

    if (!selected) {
      return nameCondition(document);
    } else {
      String fireBaseType = typesFB[types.indexOf(selectedOption)];
      if (document.get('type') != fireBaseType) {
        count--;
        return false;
      }
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
      count--;
      return false;
    }
    return true;
  }

  Future<void> getStores() async {
    QuerySnapshot snap = await FirebaseFS.getStores().get();
    for (var document in snap.docs) {
      if (document.get('project_id') == await FirebaseFS.getProjectId(uid!)) {
        stores.add(document.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    maxViewController.text = defaultMaxView.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          SizedBox(
            width: 290,
            child: TextField(
              keyboardType: TextInputType.text,
              obscureText: false,
              controller: nameController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
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
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: secondaryColor),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (first) {
                await getStores();
              }
              first = false;
              setState(() {
                if (maxViewController.text == "") {
                  maxViewController.text = defaultMaxView.toString();
                }
                currentMaxView = int.parse(maxViewController.text);
                count = 0;
              });
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return 0;
                  }
                  return 0;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return primaryColor;
                },
              ),
            ),
            child: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      drawer: NavBar(
        name: searchName!,
        email: searchEmail!,
        photo: searchPhoto!,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
              height: 680,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!selected)
                          SizedBox(
                            width: 200,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              controller: maxViewController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Vista máxima",
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
                        if (selected)
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
                              decoration: InputDecoration(
                                hintText: "Vista máxima",
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
                        Row(
                          children: [
                            if (selected)
                              const SizedBox(
                                width: 20,
                              ),
                            if (!selected)
                              const Text("Filtro",
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
                            if (selected)
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
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!first)
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
                                shrinkWrap: true,
                                itemCount: usersnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  QueryDocumentSnapshot<Object?>? document =
                                      usersnapshot.data?.docs[index];
                                  try {
                                    if (evalConditions(document) &&
                                        stores.contains(
                                            document!.get('store_id'))) {
                                      return Column(
                                        children: [
                                          ProductView(
                                            id: document.id,
                                            name: document.get('name'),
                                            description:
                                                document.get('description'),
                                            price: document
                                                .get('price')
                                                .toString(),
                                            quantity: document
                                                .get('quantity')
                                                .toString(),
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
                  ])),
        ),
      ),
    );
  }
}
