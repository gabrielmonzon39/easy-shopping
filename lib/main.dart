import 'package:easy_shopping/screens/on_board/onboard.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_shopping/auth/google_sign_in_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Easy Shopping',
          theme: ThemeData(primaryColor: const Color(0xFF4A00E0)),
          home: Onboard(),
        ),
      );
}
