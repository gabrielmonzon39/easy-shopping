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
  final maxViewController = TextEditingController();
  final defaultMaxView = 10;
  int currentMaxView = 0;
  int count = 0;
  bool valid = true;

  bool selected = true;
  String selectedOption = types[types.length - 1];

  UserBuilder() {
    currentMaxView = defaultMaxView;
  }

  bool evalConditions(QueryDocumentSnapshot<Object?>? document) {
    if (document == null) return false;
    if (document.id == "8NSZ1ielRBQyriNRwXdx") return false;
    if (document.get('quantity') <= 0) return false;

    count++;
    if (count > int.parse(maxViewController.text)) return false;
    //print(count);

    if (selected) {
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

  Future<void> checkProjectofProduct(
      QueryDocumentSnapshot<Object?>? document) async {
    valid = await FirebaseFS.checkProjectofProduct(document!.get('store_id'));
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Aqui poner ofertas");
  }
}
