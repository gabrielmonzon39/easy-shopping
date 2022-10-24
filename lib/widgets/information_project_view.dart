// ignore_for_file: must_be_immutable
import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

class InformationProjectView extends StatelessWidget {
  String? name;
  String? imageURL;

  InformationProjectView(
      {Key? key, @required this.name, @required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            name!,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 35,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageURL!,
              width: 200,
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return primaryColor;
                  },
                ),
              ),
              onPressed: () {},
              child: const Text(""),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return secondaryColor;
                  },
                ),
              ),
              onPressed: () {},
              child: const Text(""),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return ternaryColor;
                  },
                ),
              ),
              onPressed: () {},
              child: const Text(""),
            ),
          ],
        ),
      ],
    );
  }
}
