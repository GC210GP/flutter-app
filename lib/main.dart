import 'package:app/util/noti/fcm_service.dart';
import 'package:app/view/home/home_view.dart';
import 'package:app/view/signin_view.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/view/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  FcmService.startBackgroundListener();
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
