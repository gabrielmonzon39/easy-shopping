import 'package:easy_shopping/model/shopping_cart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFFFF3264);
Color secondaryColor = const Color(0xFF8200FF);
Color ternaryColor = Colors.orange;

const defaultPrimaryColor = Color(0xFFFF3264);
const defaultSecondaryColor = Color(0xFF8200FF);
const defaultTernaryColor = Colors.orange;

const bgColor = Color(0xFFFFFFFF);
const txtColor = Color(0x00000000);

/* Dark Mode*/
const primaryColorDarkM = Color(0xFF2697FF);
const secondaryColorDarkM = Color(0xFF2A2D3E);
const bgColorDarkM = Color(0xFF212332);

const defaultPadding = 16.0;

ShoppingCart? myShoppingCart;

int minBuy = 35;
const defaultMinBuy = 35;
const deliverPrice = 5;

String projectName = defaultProjectName;
String projectImage = defaultProjectImage;

const defaultProjectName = 'Easy Shopping';
const defaultProjectImage =
    'https://firebasestorage.googleapis.com/v0/b/easy-shopping-01.appspot.com/o/logo.jpg?alt=media&token=cc5dec8b-3838-4a9d-a569-e6ac6f87668c';

String? messagingToken;
late FirebaseMessaging messaging;
const serverKey =
    "AAAAhlyKLY4:APA91bESPduyiDPUTD64yvT3NwkwMcNYBdfKHNyE6ScapwrhYZX2EX8y2YIWPoeCTvwCRDgB8sxetrqDFB4inwbe0TjiEbaZYNN01PdlA0MV6Rwbu_HQTm-5WykwdL4kgfJftFA700SR";

String? searchName;
String? searchEmail;
String? searchPhoto;
