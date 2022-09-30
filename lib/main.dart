import 'package:Confessi/application/create_post/post_cubit.dart';
import 'package:Confessi/application/settings/prefs_cubit.dart';
import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/error_loading_prefs_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'constants/shared/dev.dart';
import 'application/shared/scaffold_shrinker_cubit.dart';
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'application/authentication/authentication_cubit.dart';
import 'presentation/authentication/screens/splash.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  // Locks the application to portait mode (facing up).
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      Phoenix(
        child: DevicePreview(
          enabled: kPreviewMode,
          builder: (context) => MyApp(appRouter: sl()),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  // ThemeData getLightTheme(ThemeState state) {
  //   if (state is ClassicTheme) {
  //     return AppTheme.classicLight;
  //   } else if (state is ElegantTheme) {
  //     return AppTheme.elegantLight;
  //   } else if (state is SalmonTheme) {
  //     return AppTheme.salmonLight;
  //   } else if (state is SciFiTheme) {
  //     return AppTheme.sciFiLight;
  //   } else {
  //     return AppTheme.classicLight;
  //   }
  // }

  // ThemeData getDarkTheme(ThemeState state) {
  //   if (state is ClassicTheme) {
  //     return AppTheme.classicDark;
  //   } else if (state is ElegantTheme) {
  //     return AppTheme.elegantDark;
  //   } else if (state is SalmonTheme) {
  //     return AppTheme.salmonDark;
  //   } else if (state is SciFiTheme) {
  //     return AppTheme.sciFiDark;
  //   } else {
  //     return AppTheme.classicDark;
  //   }
  // }

  ThemeMode getAppearance(AppearanceEnum state) {
    if (state == AppearanceEnum.dark) {
      return ThemeMode.dark;
    } else if (state == AppearanceEnum.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  Widget buildApp(BuildContext context, PrefsState state) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: kPreviewMode,
      title: "Confesi",
      onGenerateRoute: appRouter.onGenerateRoute,
      theme: AppTheme.classicLight,
      darkTheme: AppTheme.classicDark,
      themeMode: context.watch<PrefsCubit>().isLoaded
          ? getAppearance(
              context.watch<PrefsCubit>().prefs.appearanceEnum,
            )
          : ThemeMode.system,
      builder: DevicePreview.appBuilder,
      home: state is PrefsLoaded
          ? BlocListener<AuthenticationCubit, AuthenticationState>(
              listenWhen: (previous, current) {
                return (previous.runtimeType != current.runtimeType) &&
                    previous is! UserError;
              },
              listener: (context, state) {
                if (state is NoUser) {
                  Navigator.of(context).pushNamed("/open");
                } else if (state is User) {
                  if (state.justRegistered) {
                    Navigator.of(context).pushNamed("/onboarding");
                  } else {
                    Navigator.of(context).pushNamed("/home");
                  }
                }
              },
              child: const SplashScreen(),
            )
          : const ErrorLoadingPrefsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) =>
              sl<AuthenticationCubit>()..silentlyAuthenticateUser(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<CreatePostCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ScaffoldShrinkerCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<PrefsCubit>()..loadInitialPrefs(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return context.watch<PrefsCubit>().state is PrefsLoading
              ? Container()
              : buildApp(context, context.watch<PrefsCubit>().state);
        },
      ),
    );
  }
}
