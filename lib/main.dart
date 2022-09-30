// ignore_for_file: must_call_super

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/shopping_cart.dart';
import 'package:easy_shopping/screens/main_screens/mainscreen.dart';
import 'package:easy_shopping/screens/on_board/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSignInProvider.firebaseApp = await Firebase.initializeApp();
  initEasyLoading();
  myShoppingCart = ShoppingCart();
  runApp(const MyApp());
}

void initEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorSize = 45.0
    ..radius = 50.0
    ..userInteractions = true
    ..dismissOnTap = true;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppStateLess createState() => MyAppStateLess();
}

class MyAppStateLess extends State<MyApp> {
  bool isAlreadyLogged = false;
  String? name;
  String? email;
  String? photo;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        try {
          if (prefs.getBool('isAlreadyLogged') == null) {
            prefs.setBool('isAlreadyLogged', false);
          } else {
            isAlreadyLogged = prefs.getBool('isAlreadyLogged')!;
          }
          if (prefs.getString('name') == null) {
            prefs.setString('name', "user123");
          } else {
            name = prefs.getString('name')!;
          }
          if (prefs.getString('email') == null) {
            prefs.setString('email', "user123@gmail.com");
          } else {
            email = prefs.getString('email')!;
          }
          if (prefs.getString('photo') == null) {
            prefs.setString('photo', "userphoto");
          } else {
            photo = prefs.getString('photo')!;
          }
          if (prefs.getString('uid') == null) {
            print("PRED");
            prefs.setString('uid', "UID123");
          } else {
            uid = prefs.getString('uid')!;
          }
          if (prefs.getString('currentRoll') == null) {
            prefs.setString('currentRoll', USER);
          } else {
            currentRoll = prefs.getString('currentRoll')!;
          }
        } catch (e) {
          isAlreadyLogged = false;
          return;
        }
      });
    } catch (e) {
      isAlreadyLogged = false;
      return;
    }
    isAlreadyLogged = false;
    await FirebaseFS.saveHomeId();
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isAlreadyLogged) {
      return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Easy Shopping',
          theme: ThemeData(primaryColor: const Color(0xFF4A00E0)),
          home: const Onboard(),
          builder: EasyLoading.init(),
        ),
      );
    }
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Easy Shopping',
        theme: ThemeData(primaryColor: const Color(0xFF4A00E0)),
        home: Mainscreen(name: name, email: email, photo: photo, uid: uid),
        builder: EasyLoading.init(),
      ),
    );
  }
}
