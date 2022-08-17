import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets padding;
  // ignore: use_key_in_widget_constructors
  const TopContainer(
      {required this.height,
      required this.width,
      required this.child,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
