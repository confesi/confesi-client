import 'dart:async';

import 'application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import 'core/services/hive/hive_client.dart';
import 'core/services/user_auth/user_auth_service.dart';
import 'presentation/shared/overlays/notification_chip.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'application/feed/cubit/recents_cubit.dart';
import 'application/feed/cubit/trending_cubit.dart';
import 'application/leaderboard/cubit/leaderboard_cubit.dart';

























import 'application/shared/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'core/router/go_router.dart';
import 'core/services/fcm_notifications/notification_service.dart';
import 'core/services/user_auth/user_auth_data.dart';
import 'core/styles/themes.dart';
import 'firebase_options.dart';
import 'init.dart';

// FCM background messager handler. Required to be top-level. Needs `pragma` to prevent function being moved during release compilation.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  sl.get<NotificationService>().onMessage((p0) {
    print("backgroundMessage: $p0");
  });
}

void main() async => await init().then(
      (_) => analytics.logAppOpen().then(
            (value) => runApp(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider(lazy: false, create: (context) => sl<MapsCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<CreatePostCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<HottestCubit>()..loadPosts(DateTime.now())),
                    BlocProvider(lazy: false, create: (context) => sl<WebsiteLauncherCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<ShareCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<LeaderboardCubit>()..loadRankings()),
                    BlocProvider(lazy: false, create: (context) => sl<TrendingCubit>()..fetchPosts()),
                    BlocProvider(lazy: false, create: (context) => sl<RecentsCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<ContactSettingCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<LanguageSettingCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<AuthFlowCubit>()),
                  ],
                  child: const MyApp(),
                ),
              ),
            ),
          ),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<User?>? _userChangeStream;
  StreamSubscription<User?>? _authStateChangeStream;

  @override
  void initState() {
    startAuthListener();
    startFcmListener();
    super.initState();
  }

  @override
  void dispose() {
    _userChangeStream?.cancel();
    _authStateChangeStream?.cancel();
    sl.get<HiveService>().dispose();
    sl.get<NotificationService>().dispose();
    super.dispose();
  }

  Future<void> startAuthListener() async {
    // clear user data
    sl.get<UserAuthService>().clearCurrentExtraData();
    _authStateChangeStream = sl
        .get<FirebaseAuth>()
        .authStateChanges()
        .listen((User? user) => sl.get<NotificationService>().updateToken(user?.uid));
    _userChangeStream = sl.get<FirebaseAuth>().userChanges().listen((User? user) async {
      if (user == null) {
        await Future.delayed(const Duration(milliseconds: 500)).then((value) {
          HapticFeedback.lightImpact();
          router.go("/open");
          context.read<AuthFlowCubit>().emitDefault();
        });
      } else {
        // print("UID: ${await sl.get<FirebaseAuth>().currentUser!.getIdToken()}");
        await sl.get<UserAuthService>().getData(sl.get<FirebaseAuth>().currentUser!.uid);
        await Future.delayed(const Duration(milliseconds: 500)).then((value) {
          if (sl.get<UserAuthService>().state is! UserAuthData) {
            router.go("/error");
            context.read<AuthFlowCubit>().emitDefault();
            return;
          }
          if (user.isAnonymous) {
            sl.get<UserAuthService>().isAnon = true;
            router.go("/home");
          } else {
            sl.get<UserAuthService>().isAnon = false;
            sl.get<UserAuthService>().email = user.email!;
            if (user.emailVerified) {
              router.go("/home");
            } else {
              router.go("/verify-email");
            }
          }
          context.read<AuthFlowCubit>().emitDefault();
        });
      }
    });
  }

  Future<void> startFcmListener() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    sl.get<NotificationService>().token.then((token) {
      token.fold((l) => print(l), (r) => print(r));
    });
    sl.get<NotificationService>().requestPermissions();
    await sl.get<NotificationService>().init();
    sl.get<NotificationService>().onMessage((p0) {
      print("onMessage: $p0");
    });
    sl.get<NotificationService>().onMessageOpenedInApp((p0) {
      print("onMessageOpenedApp: $p0");
    });
    sl
        .get<NotificationService>()
        .onTokenRefresh((token) => {}); // we don't care about this, since we have our own mechanism
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<UserAuthService>(), lazy: false),
      ],
      child: Builder(
        builder: (context) {
          final data = Provider.of<UserAuthService>(context, listen: true).data();
          return BlocListener<AuthFlowCubit, AuthFlowState>(
            listenWhen: (previous, current) => true, // listen for every change
            listener: (context, state) {
              if (state is AuthFlowNotification) {
                showNotificationChip(context, state.message, notificationType: state.type);
              }
            },
            child: MaterialApp.router(
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: "Confesi",
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: data.themePref == ThemePref.system
                  ? ThemeMode.system
                  : data.themePref == ThemePref.light
                      ? ThemeMode.light
                      : ThemeMode.dark,
              builder: (BuildContext context, Widget? child) {
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                  // Force the textScaleFactor that's loaded from the device
                  // to lock to 1 (you can change it in-app independent of the inherited scale).
                  data: data.copyWith(textScaleFactor: 1),
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
