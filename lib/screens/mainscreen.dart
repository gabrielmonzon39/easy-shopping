import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/screens/header.dart';
import 'package:easy_shopping/widgets/top_container.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatelessWidget {
  var name;
  var email;

  Mainscreen({
    Key? key,
    @required this.name,
    @required this.email,
  }) : super(key: key);

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: primaryColor,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: secondaryColor,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: secondaryColor,
        body: SafeArea(
          child: Column(
            children: [
              const Header(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const CircleAvatar(
                    backgroundColor: ternaryColor,
                    radius: 35.0,
                    backgroundImage: AssetImage(
                      'assets/images/avatar.png',
                    ),
                  ),
                  Text(
                    name,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
