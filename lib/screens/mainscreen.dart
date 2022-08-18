import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/header.dart';
import 'package:easy_shopping/screens/nav_bar.dart';
import 'package:easy_shopping/widgets/top_container.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatelessWidget {
  var name;
  var email;
  var photo;
  var uid;

  Mainscreen({
    Key? key,
    @required this.name,
    @required this.email,
    @required this.photo,
    @required this.uid,
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

  Future<Widget> message() async {
    bool valid = await FirebaseFS.isAssociatedUser(uid);
    if (valid) {
      return Text('Si hay datos');
    }
    return Text("No hay datos");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Shopping'),
        backgroundColor: primaryColor,
      ),
      drawer: NavBar(
        name: name,
        email: email,
        photo: photo,
      ),
      backgroundColor: Colors.white,
      //body: message(),
      /*body: SafeArea(
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
        )*/
    );
  }
}
