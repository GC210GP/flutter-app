import 'package:app/util/network/fire_control.dart';
import 'package:app/util/noti/fcm_service.dart';
import 'package:app/util/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double logoSize = 1.0;
  final int animationDuration = 500;
  final int tmpPassTime = 3000;

  @override
  void initState() {
    worker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(bottom: 20),
              child: AnimatedScale(
                duration: Duration(milliseconds: animationDuration),
                scale: logoSize,
                curve: Curves.easeOutSine,
                child: const Image(
                  width: 60,
                  image: AssetImage("./assets/icon/applogo.png"),
                ),
              ),
            ),
            const Text(
              "나의 도움이 필요한 친구를\n찾고 있어요",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "NanumSR",
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///

  Future<void> worker() async {
    bool isAnimationRunning = true;

    FireControl.setInstanceOnce(FireControl(collectionName: "chat"));
    assert(FireControl.instance != null);

    FcmService fcmService = FcmService();

    FireControl.instance!.init().then((isOk) async {
      // FCM Setting
      await fcmService.init();
      await fcmService.getUserPermission();
      fcmService.startListener();
      debugPrint(await fcmService.getToken());

      /// Init Badge
      // TODO: 안읽은 메시지 개수 카운트 / GV.badgeCount 반영
      // FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

      if (isOk) {
        Future.delayed(const Duration(milliseconds: 2000)).then((value) {
          isAnimationRunning = false;
          Navigator.pushReplacementNamed(context, "/home");
        });
      } else {
        // TODO: Firebase 연결실패
      }
    });

    while (isAnimationRunning) {
      setState(() {
        logoSize = logoSize == 0.8 ? 1.0 : 0.8;
      });
      await Future.delayed(Duration(milliseconds: animationDuration));
    }
  }
}
