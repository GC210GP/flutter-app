import 'package:app/view/home/home_view.dart';
import 'package:app/view/signin_view.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/view/spash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
