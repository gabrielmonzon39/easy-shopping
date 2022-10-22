import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> userBNBItems = [
  BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      label: "Menú Principal",
      backgroundColor: primaryColor),
  BottomNavigationBarItem(
      icon: const Icon(Icons.store),
      label: "Tiendas",
      backgroundColor: primaryColor),
  BottomNavigationBarItem(
      icon: const Icon(Icons.timer),
      label: "Pedidos Pendientes",
      backgroundColor: primaryColor),
  BottomNavigationBarItem(
      icon: const Icon(Icons.shopping_cart),
      label: "Carrito de compras",
      backgroundColor: primaryColor),
];
