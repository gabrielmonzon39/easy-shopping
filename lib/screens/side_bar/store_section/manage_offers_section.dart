import 'dart:io';
import 'package:easy_shopping/model/category_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import 'package:easy_shopping/widgets/category_item_dart_widget.dart';
import 'package:easy_shopping/screens/side_bar/store_section/add_offers.dart';

class ManageOffersSection extends StatefulWidget {
  const ManageOffersSection({Key? key}) : super(key: key);
  @override
  ManageOffersBuilder createState() => ManageOffersBuilder();
}

class ManageOffersBuilder extends State<ManageOffersSection> {
  int i = 0;

  List<Color> gridColors = const [
    Color(0xff53B175),
    Color(0xff836AF6),
    Color(0xffD73B77),
    Color(0xffB7DFF5),
    Color(0xffF8A44C),
    Color(0xffF7A593),
    Color(0xffD3B0E0),
    Color(0xffFDE598),
  ];

  final addressController = TextEditingController();
  final quantityController = TextEditingController();

  String generatedToken = '';

  void cleanData() {
    addressController.text = "";
    quantityController.text = "";
    setState(() {});
  }

  List<Widget> getStaggeredGridView(BuildContext context) {
    List<Widget> options = [];
    for (CategoryItem item in manageOffersItemsDemo) {
      options.add(GestureDetector(
        onTap: () {
          onCategoryItemClicked(context, item);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: CategoryItemCardWidget(
            // HERE LOOP
            item: item,
            color: gridColors[(i - 1) % gridColors.length],
          ),
        ),
      ));
      options.add(const SizedBox(
        height: 20,
      ));
    }
    return options;
  }

  String storeId = "";

  void getStoreId() async {
    storeId = await FirebaseFS.getStoreId(uid!);
  }

  void onCategoryItemClicked(BuildContext context, CategoryItem categoryItem2) {
    int categoryItem = int.parse(categoryItem2.icon!);
    switch (categoryItem) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddOffersSection(
                    storeId: storeId,
                  )),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddOffersSection(
                    storeId: storeId,
                  )),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    getStoreId();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Gestionar Ofertas"),
        ),
        body: SafeArea(
            child: Container(
          margin:
              const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
          padding: const EdgeInsets.all(defaultPadding),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: getStaggeredGridView(context).length,
              itemBuilder: (context, index) {
                i++;
                return getStaggeredGridView(context)[i - 1];
              }),
        )));
  }
}
