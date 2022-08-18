import 'package:easy_shopping/constants.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.menu,
              color: secondaryColor,
              size: 30,
            ),
            onPressed: () => {},
          ),
          Text(
            "Easy Shopping",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const Icon(Icons.search, color: secondaryColor, size: 30.0),
        ],
      ),
    );
  }
}
