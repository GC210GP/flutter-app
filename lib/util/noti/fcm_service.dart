import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmService {
  late FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  late final AndroidNotificationChannel? _channel;

  ///
  ///
  ///
  /// Initialize
  Future<void> init() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    setupInteractedMessage();

    // IOS Setting
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    // Android Setting
    _channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // https://androi.tistory.com/371
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_noti_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: _handleMessageAndroid);

    await _flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel!);
  }

  ///
  ///
  ///
  /// Get user permission of notification
  Future<bool> getUserPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // print('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  ///
  ///
  ///
  /// Get FCM token
  Future<String> getToken() async {
    return await _messaging.getToken() ?? "none";
  }

  ///
  ///
  ///
  /// Start listener
  void startListener() {
    assert(_flutterLocalNotificationsPlugin != null && _channel != null,
        "FcmService was not initialized!");

    /// foreground notification
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        // TODO: 백그라운드는 반영 안됨! -> 서버 단에서 처리해줘야 함
        // print(GlobalVariables.badgetCount++);
        // FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

        debugPrint('Got a message whilst in the foreground!');
        debugPrint('data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
              'Message also contained a notification: ${message.notification}');
          debugPrint('apple: ${message.notification?.apple}');
          debugPrint('android: ${message.notification?.android}');
          debugPrint('body: ${message.notification?.body}');
          debugPrint('title: ${message.notification?.title}');
        }

        // Android
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.

        if (notification != null && android != null) {
          _flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel!.id,
                _channel!.name,
                channelDescription: _channel!.description,
                icon: android.smallIcon,
              ),
            ),
          );
        }
      },
    );
  }

  ///
  ///
  ///
  // subscribe to topic on each app start-up
  // await FirebaseMessaging.instance.subscribeToTopic('weather');
  // await FirebaseMessaging.instance.unsubscribeFromTopic('weather');

  ///
  ///
  ///
  /// Background Fetch
  static void startBackgroundListener() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  ///
  ///
  ///
  ///
  ///
  /// Inner functions

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
    debugPrint(message.data.toString());
    debugPrint("노티 터치 앱 실행");

    // TODO: 안읽은 메시지 개수 카운트 / GV.badgeCount 반영
    // FlutterAppBadger.updateBadgeCount(GlobalVariables.badgetCount);

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
