// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/main_screens/store_manager.dart';
import 'package:easy_shopping/screens/main_screens/user.dart';
import 'package:easy_shopping/screens/side_bar/nav_bar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Mainscreen extends StatelessWidget {
  var name;
  var email;
  var photo;
  var uid;

  Mainscreen({
    Key? key,
    @required this.name,
    @required this.email,
    @required this.photo,
    @required this.uid,
  }) : super(key: key);

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: primaryColor,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Future<bool> validUser() async {
    bool valid = await FirebaseFS.isAssociatedUser(uid);
    FirebaseFS.saveHomeId();
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Easy Shopping'),
          backgroundColor: primaryColor,
        ),
        drawer: NavBar(
          name: name,
          email: email,
          photo: photo,
        ),
        backgroundColor: Colors.white,
        //body: message(),
        body: SafeArea(
            child: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////////////////////////////////////////////////////////
                FutureBuilder<bool>(
                    future: validUser(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (!snapshot.hasData) {
                        // not loaded
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        // some error
                        return Column(children: const [
                          Text(
                            "Lo sentimos, ha ocurrido un error",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Icon(
                            Icons.close,
                            size: 100,
                          ),
                        ]);
                      } else {
                        // loaded
                        bool? valid = snapshot.data;
                        if (valid!) {
                          switch (currentRoll) {
                            case USER:
                              return const UserMainScreen();
                            case STORE_MANAGER:
                              return StoreManagerMainScreen();
                            case PROJECT_MANAGER:
                              return const Text(
                                  "Esta es la vista de project manager.");
                            case DELIVERY_MAN:
                              return const Text(
                                  "Esta es la vista de delivery man.");
                            case PROVIDER:
                              return const Text(
                                  "Esta es la vista de provider.");
                            case SUPER_ADMIN:
                              return const Text(
                                  "Esta es la vista de super admin.");
                            case NONE:
                              return const Text("Ha ocurrido un error.");
                          }
                        }
                      }
                      return Center(
                          child: Column(children: const [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          "¡Ups! Parece que no se encuentra registrado. Vaya a la sección de Tokens para registrarse y continuar usando nuestros servicios.",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 100,
                        ),
                      ]));
                    }),
                ////////////////////////////////////////////////////////////////
              ],
            ),
          ),
        )));
  }
}
