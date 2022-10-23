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
