import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/main_screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TokenSection extends StatelessWidget {
  final controllerKey = TextEditingController();

  TokenSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 5000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 45.0
      ..radius = 50.0
      ..userInteractions = true
      ..dismissOnTap = true;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Token"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (currentRoll == NONE)
                  const Text(
                    "Por favor, ingrese el token proporcionado por la administración de su vecindario para continuar usando nuestros servicios.",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                if (currentRoll != NONE)
                  const Text(
                    "¡Su cuenta ya ha sido registrada!",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 50,
                ),
                ////////////////////////////////////   Token   ////////////////////////////////////////////////
                if (currentRoll == NONE)
                  TextField(
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    controller: controllerKey,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff000912),
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 25),
                      hintText: "Ingrese su token",
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
                const SizedBox(
                  height: 20,
                ),
                if (currentRoll == NONE)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 25, bottom: 15),
                          child: ElevatedButton(
                            onPressed: () async {
                              String? token = controllerKey.text.toString();
                              if (token.length >= 5) {
                                bool result = await FirebaseFS.addToken(token);
                                if (result) {
                                  EasyLoading.showSuccess(
                                      'Token agregado con éxito.');
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Mainscreen(
                                            name: GoogleSignInProvider
                                                .provider!.user.displayName,
                                            email: GoogleSignInProvider
                                                .provider!.user.email,
                                            photo: GoogleSignInProvider
                                                .provider!.user.photoUrl,
                                            uid: uid),
                                      ));
                                } else {
                                  EasyLoading.showError(
                                      'Este token ya no se encuentra disponible.');
                                }
                              } else {
                                EasyLoading.showError(
                                    'Ingrese un token válido.');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.green;
                                },
                              ),
                            ),
                            child: const Text("Registrar token"),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ));
  }
}
