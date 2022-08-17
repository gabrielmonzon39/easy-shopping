import 'package:provider/provider.dart';
import '../auth/google_sign_in_provider.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Easy Shopping',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage(title: 'Easy Shopping App'),
        ),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageController controller = PageController();

  final List<Widget> _list = <Widget>[
    const Center(
        child: Pages(
      text: "Page 1",
    )),
    const Center(
        child: Pages(
      text: "Page 2",
    )),
    const Center(
        child: Pages(
      text: "Page 3",
    )),
    const Center(
        child: Pages(
      text: "Page 4",
    )),
  ];

  int _curr = 0;
  final String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          onPageChanged: (option) {
            setState(() {
              _curr = option;
            });
          },
          children: _list,
        ),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                    setState(() {
                      _list.add(
                        const Center(
                            child: Text("New page",
                                style: TextStyle(fontSize: 35.0))),
                      );
                    });
                    if (_curr != _list.length - 1) {
                      controller.jumpToPage(_curr + 1);
                    } else {
                      controller.jumpToPage(0);
                    }
                  },
                  child: const Icon(Icons.add)),
              FloatingActionButton(
                  onPressed: () {
                    _list.removeAt(_curr);
                    setState(() {
                      controller.jumpToPage(_curr - 1);
                    });
                  },
                  child: const Icon(Icons.delete)),
            ]));
  }
}

class Pages extends StatelessWidget {
  final text;
  const Pages({this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ]),
    );
  }
}
