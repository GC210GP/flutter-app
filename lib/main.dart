import 'package:blood_donation/view/home_view.dart';
import 'package:blood_donation/view/signin_view.dart';
import 'package:blood_donation/view/spash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashView(),
      routes: {
        "/home": (_) => HomeView(),
        "/signin": (_) => SigninView(),
      },
    );
  }
}
