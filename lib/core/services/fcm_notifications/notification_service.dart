import 'dart:async';

import 'package:confesi/core/services/api_client/api.dart';
import 'package:confesi/core/results/failures.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:confesi/core/services/fcm_notifications/notification_table.dart';
import 'package:confesi/core/services/fcm_notifications/token_data.dart';
import 'package:confesi/core/services/hive_client/hive_client.dart';
import 'package:confesi/init.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EmptyTokenFailure {}

class NotificationService {
  final FcmDatabase _db;

  NotificationService() : _db = FcmDatabase();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  Future<void> init() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      // todo: these fields?
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  void requestPermissions({
    bool alert = true,
    bool announcement = true,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = true,
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

  /// Deletes the token from the FCM server and removes it from local storage.
  Future<void> deleteTokenFromLocalDb() async => await _messaging.deleteToken();

  Future<Either<Failure, Success>> deleteFcmMsgFromLocalDb(int id) async {
    try {
      _db.deleteNotificationById(id);
      return Right(ApiSuccess());
    } catch (_) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, Success>> deleteAllFcmMsgsFromLocalDb() async {
    try {
      await _db.delete(_db.fcmNotifications).go();
      return Right(ApiSuccess());
    } catch (_) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List<FcmNotification>>> getAllFcmMsgsFromLocalDb() async {
    try {
      final msgs = await _db.getAllNotifications();
      return Right(msgs);
    } catch (e) {
      print(e);
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, Success>> insertFcmMsgToLocalDb(FcmNotificationCompanion entry) async {
    print("trying.......");
    try {
      await _db.insertNotification(entry);
      print("successfully inserted...");
      return Right(ApiSuccess());
    } catch (_) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List<FcmNotification>>> paginateThroughFcmMsgsFromLocalDb({
    required int limit,
    DateTime? cursor,
  }) async {
    try {
      final msgs = await _db.getNotificationsByPagination(limit: limit, cursor: cursor);
      return Right(msgs);
    } catch (_) {
      return Left(GeneralFailure());
    }
  }

  /// Call once when auth status is known, or FCM token changes.
  ///
  /// This will sync the token with the server and update local storage for it if needed.
  Future<Either<Failure, ApiSuccess>> updateToken(String? uid) async {
    final possibleCurrentFcmToken = await token;
    print("FCM TOKEN => $possibleCurrentFcmToken");
    return possibleCurrentFcmToken.fold(
      (_) => Future.value(Left(GeneralFailure())),
      (currentFcmToken) async {
        final hiveService = sl.get<HiveService>();
        final boxResult = await hiveService.getFromBoxDefaultPosition<FcmToken>();
        return boxResult.fold(
          (empty) async => await _saveTokenToServerAndLocalDb(uid, currentFcmToken),
          (previouslySavedFcmToken) async {
            if (previouslySavedFcmToken.token != currentFcmToken || previouslySavedFcmToken.withUid != (uid != null)) {
              return await _saveTokenToServerAndLocalDb(uid, currentFcmToken);
            }
            return Right(ApiSuccess());
          },
        );
      },
    );
  }

  Future<Either<Failure, ApiSuccess>> _saveTokenToServerAndLocalDb(String? uid, String token) async {
    return (await Api().req(
      Verb.post,
      uid != null,
      uid != null ? "/api/v1/notifications/token-uid" : "/api/v1/notifications/token-anon",
      {
        "token": token,
      },
    ))
        .fold(
      (_) => Left(GeneralFailure()),
      (response) async {
        if (response.statusCode.toString()[0] == "2") {
          return (await sl.get<HiveService>().putAtDefaultPosition<FcmToken>(FcmToken(uid != null, token))).fold(
            (_) => Left(GeneralFailure()),
            (success) => Right(ApiSuccess()),
          );
        } else {
          return Left(GeneralFailure());
        }
      },
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

  Future<NotificationSettings> get settings async => await _messaging.getNotificationSettings();

  void onTokenRefresh(void Function(String) callback) {
    _onTokenRefreshSubscription = _messaging.onTokenRefresh.listen(callback);
  }

  void onMessage(void Function(RemoteMessage) callback) {
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((x) {
      print("☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️");
      callback(x);
    });
  }

  void onMessageOpenedInApp(void Function(RemoteMessage) callback) {
    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(callback);
  }

  void dispose() {
    _db.close();
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
  }
}
