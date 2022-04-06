import 'package:app/util/global_variables.dart';
import 'package:app/util/network/fire_control.dart';
import 'package:app/util/theme/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

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

    FireControl.instance!.init().then((isOk) async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      print("Token: " + (await messaging.getToken() ?? "none"));

      setupInteractedMessage();

      // IOS Setting
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      // Android Setting
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // https://androi.tistory.com/371
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_stat_noti_icon');
      final InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: _handleMessageAndroid);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      ///
      ///
      /// Init Badge
      // TODO: 안읽은 메시지 개수 카운트 / GV.badgeCount 반영
      FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

      ///
      ///
      /// foreground notification
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          // TODO: 백그라운드는 반영 안됨! -> 서버 단에서 처리해줘야 함
          print(GlobalVariables.badgetCount++);
          FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

          print('Got a message whilst in the foreground!');
          print('data: ${message.data}');

          if (message.notification != null) {
            print(
                'Message also contained a notification: ${message.notification}');
            print('apple: ${message.notification?.apple}');
            print('android: ${message.notification?.android}');
            print('body: ${message.notification?.body}');
            print('title: ${message.notification?.title}');
          }

          // Android
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;

          // If `onMessage` is triggered with a notification, construct our own
          // local notification to show to users using the created channel.
          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: android.smallIcon,
                ),
              ),
            );
          }
        },
      );

      // subscribe to topic on each app start-up
      // await FirebaseMessaging.instance.subscribeToTopic('weather');
      // await FirebaseMessaging.instance.unsubscribeFromTopic('weather');

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

  ///
  ///
  ///
  ///

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.data);
    print("노티 터치 앱 실행");

    // TODO: 안읽은 메시지 개수 카운트 / GV.badgeCount 반영
    FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(
    //     context,
    //     '/chat',
    //     arguments: ChatArguments(message),
    //   );
    // }
  }

  // 역할을 잘 모르겠음..
  void _handleMessageAndroid(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }
}
