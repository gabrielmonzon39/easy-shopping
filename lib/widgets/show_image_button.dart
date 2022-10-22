// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';

class ShowImageButton extends StatelessWidget {
  String? imageName;
  String? imagePath;
  Color? buttonColor;
  ShowImageButton(
      {Key? key,
      @required this.imagePath,
      @required this.imageName,
      @required this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return buttonColor!;
            },
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(imageName!),
              content: Image.file(
                File(imagePath!),
                width: 350,
                height: 350,
              ),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.image,
            size: 30,
          ),
        ));
  }
}
