import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/main.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  var name;
  var email;
  var photo;

  NavBar({
    @required this.name,
    @required this.email,
    @required this.photo,
  });

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
            currentAccountPicture: CircleAvatar(
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
          ListTile(
            leading: Icon(Icons.groups),
            title: Text('Familiares y amigos'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Tiendas y servicios'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Historial de pedidos'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Historial de reservaciones'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text('Token'),
            onTap: () {
              //FirebaseFS.addData();
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () async {
              await GoogleSignInProvider.provider!.googleSignOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
