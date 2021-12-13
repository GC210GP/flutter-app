import 'package:blood_donation/view/home_view.dart';
import 'package:blood_donation/view/signin_view.dart';
import 'package:blood_donation/view/signup.view.dart';
import 'package:blood_donation/view/spash_view.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashView(),
      routes: {
        "/splash": (_) => SplashView(),
        "/home": (_) => HomeView(),
        "/signin": (_) => SigninView(),
        "/signup": (_) => SignupView(),
      },
    );
  }
}
