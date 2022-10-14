// ignore_for_file: must_be_immutable

import 'package:easy_shopping/constants.dart';
import 'package:flutter/cupertino.dart';

class BestSellingProductView extends StatelessWidget {
  int? pos;
  String? name;
  String? image;
  int? boughtTimes;
  int? money;

  static const Map<int, List<Color>> colors = {
    1: [Color.fromARGB(255, 204, 201, 14), Color.fromARGB(255, 243, 163, 72)],
    2: [Color.fromARGB(255, 104, 104, 101), Color.fromARGB(255, 212, 212, 210)],
    3: [Color.fromARGB(255, 124, 74, 17), Color.fromARGB(255, 172, 118, 38)]
  };

  static const List<Color> defaultColor = [
    Color.fromARGB(255, 88, 198, 202),
    Color.fromARGB(255, 80, 161, 161)
  ];

  BestSellingProductView(
      {Key? key,
      @required this.pos,
      @required this.name,
      @required this.image,
      @required this.boughtTimes,
      @required this.money})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        (pos! <= colors.length) ? colors[pos!]![0] : defaultColor[0];
    Color backgroundColor =
        (pos! <= colors.length) ? colors[pos!]![1] : defaultColor[1];
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 5,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            pos!.toString(),
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name!,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 10,
              ),
              Text("${boughtTimes!.toString()} unidades"),
              const SizedBox(
                height: 10,
              ),
              Text("Ganancia: Q${money!.toString()}"),
            ],
          ),
          Image.network(
            image!,
            width: 110,
          ),
        ],
      ),
    );
  }
}
