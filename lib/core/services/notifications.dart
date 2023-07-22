import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EmptyTokenFailure {}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  Future<void> initAndroidNotifications() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  void requestPermissions({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) async {
    await _messaging.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );
  }

  Future<Either<EmptyTokenFailure, String>> get token async {
    final token = await _messaging.getToken();
    if (token == null) {
      return Left(EmptyTokenFailure());
    } else {
      return Right(token);
    }
  }

  void fcmDeletagor({
    required RemoteMessage message,
    required Function(String title, String body) onUpdateMessage,
    required Function(String title, String body) onNotification,
  }) {
    String? dataType = message.data['type'];
    if (dataType == 'update_message') {
      String? title = message.data['title'];
      String? body = message.data['body'];
      if (title == null || body == null) return;
      onUpdateMessage(title, body);
    } else {
      RemoteNotification? notification = message.notification;
      if (notification == null) return;
      String? title = notification.title;
      String? body = notification.body;
      if (title == null || body == null) return;
      onNotification(title, body);
    }
  }

  Future<NotificationSettings> get settings async => await _messaging.getNotificationSettings();

  void subscribeToTopic(String topic) {
    _messaging.subscribeToTopic(topic);
  }

  void onTokenRefresh(void Function(String) callback) {
    _onTokenRefreshSubscription = _messaging.onTokenRefresh.listen(callback);
  }

  void onMessage(void Function(RemoteMessage) callback) {
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(callback);
  }

  void onMessageOpenedApp(void Function(RemoteMessage) callback) {
    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(callback);
  }

  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
  }
}
