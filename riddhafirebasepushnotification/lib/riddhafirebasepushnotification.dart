library riddhafirebasepushnotification;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RiddhaFirebasePushNotificationService {
  RiddhaFirebasePushNotificationService();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // tit, // description
      importance: Importance.high,
      playSound: true);

  initRiddhaFirebasePushNotificaiton() async {
    await _firebaseInitialization();
    _firebaseOnMessageListener();
  }

  _firebaseInitialization() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message ${message.data}");
    await Firebase.initializeApp();
  }

  Future getDeviceToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  _firebaseOnMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        var notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            enableVibration: true,
            importance: Importance.high,
            visibility: NotificationVisibility.public,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        );
        _flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, notificationDetails);
      }
    });
  }

  onRiddhaFirebaseOpenedMessage(context, {child}) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      child;
    });
  }
}
