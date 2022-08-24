import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class StoreManagerMainScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  StoreManagerMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 5000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 45.0
      ..radius = 50.0
      ..userInteractions = true
      ..dismissOnTap = true;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ////////////////////////////////////////////////////////////////////////////////////
            TextField(
              keyboardType: TextInputType.text,
              obscureText: false,
              controller: nameController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff000912),
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "Nombre del producto",
                hintStyle: TextStyle(
                  color: Color(0xffA6B0BD),
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: Colors.black,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 75,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: false,
              controller: descriptionController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff000912),
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: "Descripción del producto",
                hintStyle: TextStyle(
                  color: Color(0xffA6B0BD),
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: Colors.black,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 75,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: descriptionController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000912),
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 25),
                    hintText: "Precio",
                    hintStyle: TextStyle(
                      color: Color(0xffA6B0BD),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 75,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: descriptionController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000912),
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 25),
                    hintText: "Existencias",
                    hintStyle: TextStyle(
                      color: Color(0xffA6B0BD),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 75,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
