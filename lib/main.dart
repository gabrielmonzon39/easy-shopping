import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/shopping_cart.dart';
import 'package:easy_shopping/screens/on_board/onboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:easy_shopping/auth/google_sign_in_provider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Easy Shopping',
          theme: ThemeData(primaryColor: const Color(0xFF4A00E0)),
          home: const Onboard(),
          builder: EasyLoading.init(),
        ),
      );
}
