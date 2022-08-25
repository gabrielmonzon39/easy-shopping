// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class InformationUserView extends StatelessWidget {
  String? name;
  String? email;
  String? imageURL;
  String? creationTime;
  String? lastSignInTime;

  InformationUserView(
      {Key? key,
      @required this.name,
      @required this.email,
      @required this.imageURL,
      @required this.creationTime,
      @required this.lastSignInTime})
      : super(key: key);

  void adjustDate() {
    creationTime = creationTime!.split(" ").first;
    lastSignInTime = lastSignInTime!.split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    adjustDate();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageURL!,
              width: 100,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        name!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 35,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          email!,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          'Fecha de creación: $creationTime',
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Última fecha de acceso: $lastSignInTime',
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}
