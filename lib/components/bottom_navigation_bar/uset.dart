import 'package:easy_shopping/screens/side_bar/user_section/information_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/pending_order_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/shopping_cart_section.dart';
import 'package:easy_shopping/screens/side_bar/user_section/store_section.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getUserBNBItems(Color col) {
  return [
    BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: "Menú Principal",
        backgroundColor: col),
    BottomNavigationBarItem(
        icon: const Icon(Icons.store), label: "Tiendas", backgroundColor: col),
    BottomNavigationBarItem(
        icon: const Icon(Icons.timer),
        label: "Pedidos Pendientes",
        backgroundColor: col),
    BottomNavigationBarItem(
        icon: const Icon(Icons.shopping_cart),
        label: "Carrito de compras",
        backgroundColor: col),
  ];
}

final screens = <Widget>[
  const UserInformationSection(),
  const StoresSection(),
  const PendingOrderSection(),
  const ShoppingCartSection()
];
