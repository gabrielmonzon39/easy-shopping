// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:easy_shopping/components/fading_sliding_widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 100,
          left: 20,
          child: Container(
            height: width * 0.1,
            width: width * 0.1,
            decoration: const ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00FFDC),
                    Color(0xFF5096FE),
                  ],
                )),
          ),
        ),
        Positioned(
          top: height * 0.2,
          child: Column(
            children: <Widget>[
              ScaleTransition(
                scale: _animationController.drive(
                  Tween<double>(begin: 0.3, end: 1.0).chain(
                    CurveTween(
                      curve:
                          const Interval(0.0, 0.2, curve: Curves.elasticInOut),
                    ),
                  ),
                ),
                child: FadeTransition(
                  opacity: _animationController.drive(
                    Tween<double>(begin: 0.0, end: 1.0).chain(
                      CurveTween(
                        curve:
                            const Interval(0.2, 0.4, curve: Curves.decelerate),
                      ),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: _animationController.drive(
                      Tween<double>(begin: 1.3, end: 1.0).chain(
                        CurveTween(
                          curve: const Interval(0.2, 0.4,
                              curve: Curves.elasticInOut),
                        ),
                      ),
                    ),
                    child: Container(
                      width: width * 0.3,
                      height: width * 0.3,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.08),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        scale: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              FadingSlidingWidget(
                animationController: _animationController,
                interval: const Interval(0.5, 0.9),
                child: Text(
                  'Easy Shopping',
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: width * 0.08,
                    fontFamily: 'ProductbSans',
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.2,
              ),
              SizedBox(
                width: width * 0.9,
                child: FadingSlidingWidget(
                  animationController: _animationController,
                  interval: const Interval(0.7, 1.0),
                  child: Text(
                    'Busca, compra y recibe con tan solo presionar un botón.',
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: width * 0.056,
                      fontFamily: 'ProductSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
