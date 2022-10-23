// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore, no_logic_in_create_state, library_private_types_in_public_api, must_be_immutable

import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/main.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/side_bar/delivery_man_section/active_orders.dart';
import 'package:easy_shopping/screens/side_bar/delivery_man_section/delivery_history.dart';
import 'package:easy_shopping/screens/side_bar/delivery_man_section/orders_to_deliver.dart';
import 'package:easy_shopping/screens/side_bar/project_manager_section/settings_project_manager.dart';
import 'package:easy_shopping/screens/side_bar/store_section/add_products.dart';
import 'package:easy_shopping/screens/side_bar/store_section/best_selling_products.dart';
import 'package:easy_shopping/screens/side_bar/store_section/income.dart';
import 'package:easy_shopping/screens/side_bar/store_section/information_section.dart';
import 'package:easy_shopping/screens/side_bar/store_section/products_section.dart';
import 'package:easy_shopping/screens/side_bar/store_section/settings.dart';
import 'package:easy_shopping/screens/side_bar/store_section/store_sales_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/family_section.dart';
import 'package:easy_shopping/screens/side_bar/options_conditions.dart';
import 'package:easy_shopping/screens/side_bar/general_section/token_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/information_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/order_history_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/pending_order_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/shopping_cart_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/store_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
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
  _NavBar createState() => _NavBar(email: email, photo: photo, name: name);
}

// ignore: must_be_immutable
class _NavBar extends State<NavBar> {
  var name;
  var email;
  var photo;

  _NavBar({
    @required this.name,
    @required this.email,
    @required this.photo,
  });

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
              currentAccountPicture: CircleAvatar(
                backgroundColor: ternaryColor,
                radius: 35.0,
                backgroundImage: const AssetImage(
                  'assets/images/logo.jpg',
                ),
              ),
              decoration: BoxDecoration(
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

            /// **************  Pedidos pendientes  **************
            if (OptionConditions.pendingOrder())
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Pedidos pendientes de entrega'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PendingOrderSection(),
                      ));
                },
              ),
            if (OptionConditions.pendingOrder()) const Divider(),

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

            ///////////////////////////////////////////////////////////////
            /////////////////    DELIVERY MAN OPTIONS     /////////////////
            ///////////////////////////////////////////////////////////////

            /// **************  Ordenes por entregar  **************
            if (OptionConditions.ordersToDeliver())
              ListTile(
                leading: const Icon(Icons.delivery_dining),
                title: const Text('Órdenes por entregar'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrdersToDeliver()),
                  );
                },
              ),
            if (OptionConditions.ordersToDeliver()) const Divider(),

            /// **************  Ordenes activas  **************
            if (OptionConditions.activeOrders())
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('Órdenes activas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ActiveOrders()),
                  );
                },
              ),
            if (OptionConditions.activeOrders()) const Divider(),

            /// **************  Ordenes entregadas  **************
            if (OptionConditions.deliveryHistory())
              ListTile(
                leading: const Icon(Icons.pending_actions),
                title: const Text('Órdenes entregadas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeliveryHistory()),
                  );
                },
              ),
            if (OptionConditions.deliveryHistory()) const Divider(),

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

            /// **************  Productos más vendidos  **************
            if (OptionConditions.bestSellingProducts())
              ListTile(
                leading: const Icon(Icons.sell),
                title: const Text('Los más vendidos'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BestSellingProducts(),
                      ));
                },
              ),
            if (OptionConditions.bestSellingProducts()) const Divider(),

            /// **************  Ganancias  **************
            if (OptionConditions.income())
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Ganancias'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Income(),
                      ));
                },
              ),
            if (OptionConditions.income()) const Divider(),

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

            /// **************  Configuración  **************
            if (OptionConditions.settings())
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () async {
                  String projectId = await FirebaseFS.getProjectId(uid!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsSection(
                              projectId: projectId,
                            )),
                  );
                },
              ),
            if (OptionConditions.settings()) const Divider(),

            //////////////////////////////////////////////////////
            /////////////////   PROJECT MANAGER  /////////////////
            //////////////////////////////////////////////////////

            /// **************  Configuración  **************
            if (OptionConditions.settingsProjectManager())
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPMSection()),
                  );
                },
              ),
            if (OptionConditions.settingsProjectManager()) const Divider(),

            /////////////////////////////////////////////////////////
            /////////////////    GENERAL OPTIONS    /////////////////
            /////////////////////////////////////////////////////////

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

            /// **************  Noticias  **************
            if (OptionConditions.notifications())
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Noticias'),
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
                      MaterialPageRoute(
                          builder: (context) => TokenSection())).then((value) {
                    setState(() {
                      // refresh state
                    });
                  });
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
                  await GoogleSignInProvider.provider!.googleSignOut(context);
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
