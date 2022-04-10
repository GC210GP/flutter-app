import 'package:app/util/global_variables.dart';
import 'package:app/util/network/fire_control.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/noti/fcm_service.dart';
import 'package:app/util/preference_manager.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/view/message_view.dart';
import 'package:app/view/signin_view.dart';
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
    GlobalVariables.currentContext = context;
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
      await fcmService.init(onNotificationArrived: (data) {
        Navigator.push(
          GlobalVariables.currentContext!,
          MaterialPageRoute(
            builder: (_) => MessageView(
              fromId: data.fromId,
              toId: data.toId,
            ),
          ),
        );
      });
      await fcmService.getUserPermission();
      fcmService.startListener();
      GlobalVariables.fcmToken = await fcmService.getToken();
      debugPrint(GlobalVariables.fcmToken);

      /// Init Badge
      // TODO: 안읽은 메시지 개수 카운트 / GV.badgeCount 반영
      // FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

      if (isOk) {
        // Token 검사 / 세션 유지 진행
        await PreferenceManager.instance.init();

        GlobalVariables.savedEmail =
            PreferenceManager.instance.read(PrefItem.savedEmail) ?? "";

        if (PreferenceManager.instance.read(PrefItem.token) != null) {
          GlobalVariables.httpConn
              .setHeaderToken(PreferenceManager.instance.read(PrefItem.token)!);

          Map<String, dynamic> userResult =
              await GlobalVariables.httpConn.get(apiUrl: "/users/current");

          if (userResult['httpConnStatus'] == httpConnStatus.success) {
            GlobalVariables.userDto = readUserDto(userResult);
          }
        }

        // 마무리
        await Future.delayed(const Duration(milliseconds: 2000));
        isAnimationRunning = false;
        Navigator.pushReplacementNamed(context, "/home");
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
