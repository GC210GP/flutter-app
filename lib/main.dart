import 'package:blood_donation/view/home_view.dart';
import 'package:blood_donation/view/signin_view.dart';
import 'package:blood_donation/view/signup.view.dart';
import 'package:blood_donation/view/spash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashView(),
      routes: {
        "/splash": (_) => const SplashView(),
        "/home": (_) => const HomeView(),
        "/signin": (_) => const SigninView(),
        "/signup": (_) => const SignupView(),
      },
    );
  }
}
