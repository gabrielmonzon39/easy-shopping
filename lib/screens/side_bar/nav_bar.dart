// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore

import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/main.dart';
import 'package:easy_shopping/screens/side_bar/store_section/add_products.dart';
import 'package:easy_shopping/screens/side_bar/store_section/information_section.dart';
import 'package:easy_shopping/screens/side_bar/store_section/products_section.dart';
import 'package:easy_shopping/screens/side_bar/store_section/store_sales_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/family_section.dart';
import 'package:easy_shopping/screens/side_bar/options_conditions.dart';
import 'package:easy_shopping/screens/side_bar/general_section/token_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/information_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/order_history_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/shopping_cart_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/store_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return SizedBox(
      width: 310,
      child: Drawer(
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

            /// **************  Tiendas  **************
            if (OptionConditions.stores())
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Tiendas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoresSection()),
                  );
                },
              ),
            if (OptionConditions.stores()) const Divider(),

            /// **************  Servicios  **************
            if (OptionConditions.services())
              ListTile(
                leading: const Icon(Icons.room_service),
                title: const Text('Servicios'),
                onTap: () {},
              ),
            if (OptionConditions.services()) const Divider(),

            /// **************  Carrito de compras  **************
            if (OptionConditions.shoppingCart())
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Carrito de compras'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingCartSection(),
                      ));
                },
              ),
            if (OptionConditions.shoppingCart()) const Divider(),

            /// **************  Historial de pedidos  **************
            if (OptionConditions.orderHistory())
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Historial de compras'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderHistorySection(),
                      ));
                },
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

            /// **************  Información  **************
            if (OptionConditions.userInformation())
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Información'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserInformationSection()),
                  );
                },
              ),
            if (OptionConditions.userInformation()) const Divider(),

            ///////////////////////////////////////////////////////////////
            /////////////////    STORE MANAGER OPTIONS    /////////////////
            ///////////////////////////////////////////////////////////////

            /// **************  Ingresar productos  **************
            if (OptionConditions.addProducts())
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Ingresar producto'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProductsSection()),
                  );
                },
              ),
            if (OptionConditions.addProducts()) const Divider(),

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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StoreSalesSection(),
                      ));
                },
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
                        builder: (context) => const StoreInformationSection()),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isAlreadyLogged', false);
                  GoogleSignInProvider.provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await GoogleSignInProvider.provider!.googleSignOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
              ),
            if (OptionConditions.logOut()) const Divider(),
          ],
        ),
      ),
    );
  }
}
