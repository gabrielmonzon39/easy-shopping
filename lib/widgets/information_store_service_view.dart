// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class InformationStoreServiceView extends StatelessWidget {
  String? name;
  String? description;
  String? imageURL;

  InformationStoreServiceView(
      {Key? key,
      @required this.name,
      @required this.description,
      @required this.imageURL})
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
              color: Colors.white,
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
        Text(
          description!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
