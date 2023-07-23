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
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'init.dart';
import 'presentation/primary/screens/splash.dart';

void main() async => await init().then((_) => analytics.logAppOpen().then((value) => runApp(MyApp(appRouter: sl()))));

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  ThemeMode getAppearance(AppearanceEnum state) {
    if (state == AppearanceEnum.dark) {
      return ThemeMode.dark;
    } else if (state == AppearanceEnum.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => sl<MapsCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<DraftsCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<CreatePostCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<HottestCubit>()..loadPosts(DateTime.now()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<WebsiteLauncherCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ShareCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<UserCubit>()..loadUser(true), // TODO: fix auth once server is ready
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<RegisterCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            onGenerateRoute: appRouter.onGenerateRoute,
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
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
