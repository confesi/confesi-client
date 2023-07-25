import 'dart:async';

import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'application/feed/cubit/recents_cubit.dart';
import 'application/feed/cubit/trending_cubit.dart';
import 'application/leaderboard/cubit/leaderboard_cubit.dart';
import 'application/profile/cubit/biometrics_cubit.dart';
import 'application/shared/cubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/authentication_and_settings/cubit/login_cubit.dart';
import 'application/authentication_and_settings/cubit/register_cubit.dart';
import 'application/authentication_and_settings/cubit/user_cubit.dart';
import 'application/create_post/cubit/drafts_cubit.dart';
import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'constants/enums_that_are_local_keys.dart';
import 'core/router/go_router.dart';
import 'core/styles/themes.dart';
import 'init.dart';

void main() async => await init().then(
      (_) => analytics.logAppOpen().then(
            (value) => runApp(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                home: DevicePreview(builder: (context) => const MyApp()),
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
    super.initState();
    updateAuthState();
  }

  @override
  void dispose() {
    // Dispose of the stream subscription when the widget is disposed
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> updateAuthState() async {
    // delay for the splash screen
    await Future.delayed(const Duration(milliseconds: 500));
    // await sl.get<FirebaseAuth>().signOut();
    _authStateSubscription = sl.get<FirebaseAuth>().authStateChanges().listen((User? user) {
      if (user == null) {
        sl
            .get<UserAuthService>()
            .setNoData()
            .then((_) => sl.get<UserAuthService>().state is UserAuthNoData ? router.go("/open") : router.go("/error"));
      } else {
        sl.get<UserAuthService>().setData().then((_) {
          if (sl.get<UserAuthService>().state is! UserAuthData) {
            router.go("/error");
            return;
          }
        });
        if (user.isAnonymous) {
          router.go("/home");
        } else {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (context) => sl<MapsCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<DraftsCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<CreatePostCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<HottestCubit>()..loadPosts(DateTime.now())),
        BlocProvider(lazy: false, create: (context) => sl<WebsiteLauncherCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<ShareCubit>()),
        BlocProvider(
            lazy: false, create: (context) => sl<UserCubit>()..loadUser(true)), // TODO: fix auth once server is ready
        BlocProvider(lazy: false, create: (context) => sl<LoginCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<RegisterCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<LeaderboardCubit>()..loadRankings()),
        BlocProvider(lazy: false, create: (context) => sl<TrendingCubit>()..fetchPosts()),
        BlocProvider(lazy: false, create: (context) => sl<RecentsCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<BiometricsCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<ContactSettingCubit>()),
        BlocProvider(lazy: false, create: (context) => sl<LanguageSettingCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: context.watch<UserCubit>().stateIsUser
                // If state is user, then use their preferences
                ? getAppearance(context.watch<UserCubit>().stateAsUser.appearanceEnum)
                // Otherwise, just go dark
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
          );
        },
      ),
    );
  }
}
