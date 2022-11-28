// ignore_for_file: must_be_immutable
import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

class NewsView extends StatelessWidget {
  String? title;
  String? body;
  String? date;
  String? image;

  NewsView({
    Key? key,
    @required this.title,
    @required this.body,
    @required this.date,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(title!),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: ternaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Image.network(
                image!,
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              body!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
