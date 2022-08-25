// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/main.dart';
import 'package:easy_shopping/screens/side_bar/store_section/information_section.dart';
import 'package:easy_shopping/screens/side_bar/store_section/products_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/family_section.dart';
import 'package:easy_shopping/screens/side_bar/options_conditions.dart';
import 'package:easy_shopping/screens/side_bar/general_section/token_section.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NavBar extends StatelessWidget {
  var name;
  var email;
  var photo;

  NavBar({
    Key? key,
    @required this.name,
    @required this.email,
    @required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: ternaryColor,
              radius: 35.0,
              backgroundImage: AssetImage(
                'assets/images/avatar.png',
              ),
            ),
            decoration: const BoxDecoration(
              color: secondaryColor,
            ),
          ),

          //////////////////////////////////////////////////////
          /////////////////    USER OPTIONS    /////////////////
          //////////////////////////////////////////////////////

          /// **************  Familiares y amigos  **************
          if (OptionConditions.familyAndFriends())
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text('Familiares y amigos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FamilySection()),
                );
              },
            ),
          if (OptionConditions.familyAndFriends()) const Divider(),

          /// **************  Tiendas y servicios  **************
          if (OptionConditions.storesAndServices())
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Tiendas y servicios'),
              onTap: () {},
            ),
          if (OptionConditions.storesAndServices()) const Divider(),

          /// **************  Historial de pedidos  **************
          if (OptionConditions.orderHistory())
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Historial de pedidos'),
              onTap: () {},
            ),
          if (OptionConditions.orderHistory()) const Divider(),

          /// **************  Historial de reservaciones  **************
          if (OptionConditions.reservationsHistory())
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Historial de reservaciones'),
              onTap: () {},
            ),
          if (OptionConditions.reservationsHistory()) const Divider(),

          ///////////////////////////////////////////////////////////////
          /////////////////    STORE MANAGER OPTIONS    /////////////////
          ///////////////////////////////////////////////////////////////

          /// **************  Mis productos  **************
          if (OptionConditions.storeProducts())
            ListTile(
              leading: const Icon(Icons.local_grocery_store),
              title: const Text('Mis productos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductsSection()),
                );
              },
            ),
          if (OptionConditions.storeProducts()) const Divider(),

          /// **************  Mis ventas  **************
          if (OptionConditions.storeSales())
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Mis ventas'),
              onTap: () {},
            ),
          if (OptionConditions.storeSales()) const Divider(),

          /// **************  Información  **************
          if (OptionConditions.storeInformation())
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Información'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InformationSection()),
                );
              },
            ),
          if (OptionConditions.storeInformation()) const Divider(),

          /////////////////////////////////////////////////////////
          /////////////////    GENERAL OPTIONS    /////////////////
          /////////////////////////////////////////////////////////

          /// **************  Notificaciones  **************
          if (OptionConditions.notifications())
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              onTap: () {},
            ),
          if (OptionConditions.notifications()) const Divider(),

          /// **************  Token  **************
          if (OptionConditions.token())
            ListTile(
              leading: const Icon(Icons.vpn_key),
              title: const Text('Token'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TokenSection()),
                );
              },
            ),
          if (OptionConditions.token()) const Divider(),

          /// **************  Cerrar sesión  **************
          if (OptionConditions.logOut())
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await GoogleSignInProvider.provider!.googleSignOut();
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          if (OptionConditions.logOut()) const Divider(),
        ],
      ),
    );
  }
}
