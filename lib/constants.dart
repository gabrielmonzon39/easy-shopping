import 'package:easy_shopping/model/shopping_cart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFF3264);
const secondaryColor = Color(0xFF8200FF);
const ternaryColor = Colors.orange;
const bgColor = Color(0xFFFFFFFF);
const txtColor = Color(0x00000000);

/* Dark Mode*/
const primaryColorDarkM = Color(0xFF2697FF);
const secondaryColorDarkM = Color(0xFF2A2D3E);
const bgColorDarkM = Color(0xFF212332);

const defaultPadding = 16.0;
ShoppingCart? myShoppingCart;

const minBuy = 35;
const deliverPrice = 5;
String? messagingToken;
late FirebaseMessaging messaging;
const serverKey =
    "AAAAhlyKLY4:APA91bESPduyiDPUTD64yvT3NwkwMcNYBdfKHNyE6ScapwrhYZX2EX8y2YIWPoeCTvwCRDgB8sxetrqDFB4inwbe0TjiEbaZYNN01PdlA0MV6Rwbu_HQTm-5WykwdL4kgfJftFA700SR";
