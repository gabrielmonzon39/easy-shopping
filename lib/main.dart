// ignore_for_file: must_call_super, avoid_print

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/colors.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/model/name_and_logo.dart';
import 'package:easy_shopping/model/shopping_cart.dart';
import 'package:easy_shopping/screens/main_screens/mainscreen.dart';
import 'package:easy_shopping/screens/on_board/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSignInProvider.firebaseApp = await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  initEasyLoading();
  myShoppingCart = ShoppingCart();
  runApp(const MyApp());
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
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
    messaging = FirebaseMessaging.instance;
    messagingToken = await messaging.getToken();
    minBuy = await FirebaseFS.getMinBuy();
    //print("-------------------FUNCOOOOOOOOO-----------------------");
    try {
      setState(() async {
        isAlreadyLogged = prefs.getBool('isAlreadyLogged')!;
        name = prefs.getString('name');
        email = prefs.getString('email');
        photo = prefs.getString('photo');
        uid = prefs.getString('uid');
        currentRoll = prefs.getString('role')!;
        await FirebaseFS.saveHomeId();
        await getAndSetColors();
      });
    } catch (e) {
      isAlreadyLogged = false;
    }

    try {
      projectName = prefs.getString('project_name')!;
      projectImage = prefs.getString('project_image')!;
    } catch (e) {
      projectName = defaultProjectName;
      projectImage = defaultProjectImage;
    }
  }

  @override
  void initState() {
    getData();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Notificaci??n"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });*/
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
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
