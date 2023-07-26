import 'dart:async';

import 'package:confesi/application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import 'package:confesi/core/services/hive/hive_client.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/presentation/shared/overlays/notification_chip.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'application/feed/cubit/recents_cubit.dart';
import 'application/feed/cubit/trending_cubit.dart';
import 'application/leaderboard/cubit/leaderboard_cubit.dart';
import 'application/profile/cubit/biometrics_cubit.dart';
import 'application/shared/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'constants/enums_that_are_local_keys.dart';
import 'core/router/go_router.dart';
import 'core/services/user_auth/user_auth_data.dart';
import 'core/styles/themes.dart';
import 'init.dart';

void main() async => await init().then(
      (_) => analytics.logAppOpen().then(
            (value) => runApp(
              const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
            ),
          ),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode getAppearance(AppearanceEnum state) {
    if (state == AppearanceEnum.dark) {
      return ThemeMode.dark;
    } else if (state == AppearanceEnum.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    updateAuthState();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the stream subscription when the widget is disposed
    _authStateSubscription?.cancel();
    sl.get<HiveService>().dispose();
    super.dispose();
  }

  Future<void> updateAuthState() async {
    // clear user data
    // todo: disabled
    sl.get<UserAuthService>().clearCurrentExtraData();
    _authStateSubscription = sl.get<FirebaseAuth>().idTokenChanges().listen((User? user) async {
      if (sl.get<FirebaseAuth>().currentUser.isDisabled) {
        router.go("/disabled");
      }
    });
    _authStateSubscription = sl.get<FirebaseAuth>().authStateChanges().listen((User? user) async {
      if (user == null) {
        await Future.delayed(const Duration(milliseconds: 500)); // wait on the splash screen to avoid jank
        router.go("/open");
      } else {
        await sl.get<UserAuthService>().getData(sl.get<FirebaseAuth>().currentUser!.uid);
        await Future.delayed(const Duration(milliseconds: 500)); // wait on the splash screen to avoid jank
        if (sl.get<UserAuthService>().state is! UserAuthData) {
          router.go("/error");
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<UserAuthService>(), lazy: false),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(lazy: false, create: (context) => sl<MapsCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<CreatePostCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<HottestCubit>()..loadPosts(DateTime.now())),
          BlocProvider(lazy: false, create: (context) => sl<WebsiteLauncherCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<ShareCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<LeaderboardCubit>()..loadRankings()),
          BlocProvider(lazy: false, create: (context) => sl<TrendingCubit>()..fetchPosts()),
          BlocProvider(lazy: false, create: (context) => sl<RecentsCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<BiometricsCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<ContactSettingCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<LanguageSettingCubit>()),
          BlocProvider(lazy: false, create: (context) => sl<AuthFlowCubit>()),
        ],
        child: Builder(
          builder: (context) {
            final data = Provider.of<UserAuthService>(context, listen: true).data();
            return BlocListener<AuthFlowCubit, AuthFlowState>(
              listenWhen: (previous, current) => true, // listen for every change
              listener: (context, state) {
                if (state is AuthFlowEnteringData && state.mode is EnteringError) {
                  showNotificationChip(context, (state.mode as EnteringError).message);
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
      ),
    );
  }
}
