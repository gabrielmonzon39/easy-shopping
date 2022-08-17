import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_shopping/model/onboard_page_item.dart';
import 'package:easy_shopping/components/fading_sliding_widget.dart';
import 'package:easy_shopping/screens/on_board/welcome_page.dart';
import 'package:easy_shopping/screens/on_board/onboard_page.dart';
import 'package:easy_shopping/screens/mainscreen.dart';
import 'package:easy_shopping/auth/google_sign_in_provider.dart';

class Onboard extends StatefulWidget {
  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> with SingleTickerProviderStateMixin {
  List<OnboardPageItem> onboardPageItems = [
    OnboardPageItem(
      lottieAsset: 'assets/animations/home.json',
      text: 'Ordena desde tu casa.',
      animationDuration: const Duration(milliseconds: 1100),
    ),
    OnboardPageItem(
      lottieAsset: 'assets/animations/activity.json',
      text: 'Sabemos que tu tiempo es importante.',
      animationDuration: const Duration(milliseconds: 1100),
    ),
    OnboardPageItem(
      lottieAsset: 'assets/animations/group_working.json',
      text:
          'Continúa con tus labores mientras tu pedido llega hasta la puerta de tu casa.',
      animationDuration: const Duration(milliseconds: 1100),
    ),
  ];

  late PageController _pageController;
  List<Widget> onboardItems = [];
  late double _activeIndex;
  bool onboardPage = false;
  late AnimationController _animationController;

  @override
  void initState() {
    initializePages(); //initialize pages to be shown
    _pageController = PageController();
    _pageController.addListener(() {
      _activeIndex = _pageController.page!;
      if (_activeIndex >= 0.5 && onboardPage == false) {
        setState(() {
          onboardPage = true;
        });
      } else if (_activeIndex < 0.5) {
        setState(() {
          onboardPage = false;
        });
      }
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    super.initState();
  }

  initializePages() {
    onboardItems.add(WelcomePage()); // welcome page
    for (var onboardPageItem in onboardPageItems) {
      //adding onboard pages
      onboardItems.add(OnboardPage(
        onboardPageItem: onboardPageItem,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: onboardItems,
            ),
          ),
          Positioned(
            bottom: height * 0.15,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardItems.length,
              effect: WormEffect(
                dotWidth: width * 0.03,
                dotHeight: width * 0.03,
                dotColor: onboardPage
                    ? const Color(0x11000000)
                    : const Color(0x566FFFFFF),
                activeDotColor: onboardPage
                    ? const Color(0xFF9544d0)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.googleLogin();
                // ignore: use_build_context_synchronously
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Mainscreen(
                      name: provider.user.displayName,
                      email: provider.user.email);
                }));
              },
              child: FadingSlidingWidget(
                animationController: _animationController,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  alignment: Alignment.center,
                  width: width * 0.8,
                  height: height * 0.075,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.1),
                    ),
                    gradient: LinearGradient(
                      colors: onboardPage
                          ? [
                              const Color(0xFF8200FF),
                              const Color(0xFFFF3264),
                            ]
                          : [
                              const Color(0xFFFFFFFF),
                              const Color(0xFFFFFFFF),
                            ],
                    ),
                  ),
                  child: Text(
                    'Iniciar sesión con Google',
                    style: TextStyle(
                      color: onboardPage
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF220555),
                      fontSize: width * 0.05,
                      fontFamily: 'ProductSans',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
