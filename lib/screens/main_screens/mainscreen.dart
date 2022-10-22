// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state, must_be_immutable, library_private_types_in_public_api, duplicate_ignore, use_key_in_widget_constructors

import 'package:easy_shopping/components/bottom_navigation_bar/uset.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/extra/user/search.dart';
import 'package:easy_shopping/screens/main_screens/delivery_man.dart';
import 'package:easy_shopping/screens/main_screens/project_manager.dart';
import 'package:easy_shopping/screens/main_screens/store_manager.dart';
import 'package:easy_shopping/screens/main_screens/super_admin.dart';
import 'package:easy_shopping/screens/main_screens/user.dart';
import 'package:easy_shopping/screens/side_bar/nav_bar.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  var name;
  var email;
  var photo;
  var uid;

  Mainscreen({
    @required this.name,
    @required this.email,
    @required this.photo,
    @required this.uid,
  });

  @override
  _MainscreenState createState() =>
      _MainscreenState(email: email, photo: photo, name: name, uid: uid);
}

// ignore: must_be_immutable
class _MainscreenState extends State<Mainscreen> {
  var name;
  var email;
  var photo;
  var uid;
  int currentIndex = 0;

  _MainscreenState({
    @required this.name,
    @required this.email,
    @required this.photo,
    @required this.uid,
  });

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
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
    searchName = name;
    searchEmail = email;
    searchPhoto = photo;
    if (currentRoll == USER) {
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => setState(() {
                    currentIndex = index;
                  }),
              items: userBNBItems),
          appBar: AppBar(
            title: const Text('Easy Shopping'),
            backgroundColor: primaryColor,
            actions: [
              if (currentRoll == USER)
                ElevatedButton(
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
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Search()),
                    );
                  },
                  child: const Icon(Icons.search),
                )
            ],
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
                                return ProjectManagerMainScreen();
                              case DELIVERY_MAN:
                                return DeliveryManMainScreen();
                              case SUPER_ADMIN:
                                return SuperAdminMainScreen();
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Easy Shopping'),
          backgroundColor: primaryColor,
          actions: [
            if (currentRoll == USER)
              ElevatedButton(
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
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Search()),
                  );
                },
                child: const Icon(Icons.search),
              )
          ],
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
                              return ProjectManagerMainScreen();
                            case DELIVERY_MAN:
                              return DeliveryManMainScreen();
                            case SUPER_ADMIN:
                              return SuperAdminMainScreen();
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
