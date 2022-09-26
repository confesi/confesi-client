import 'package:Confessi/application/create_post/post_cubit.dart';
import 'package:Confessi/application/settings/theme_cubit.dart';
import 'package:Confessi/presentation/authentication/screens/home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/settings/appearance_cubit.dart';
import 'application/settings/biometrics_enabled_cubit.dart';
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
      DevicePreview(
        enabled: kPreviewMode,
        builder: (context) => MyApp(appRouter: sl()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  ThemeMode getAppearance(AppearanceState state) {
    if (state is Dark) {
      return ThemeMode.dark;
    } else if (state is Light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  ThemeData getLightTheme(ThemeState state) {
    if (state is ClassicTheme) {
      return AppTheme.classicLight;
    } else if (state is ElegantTheme) {
      return AppTheme.elegantLight;
    } else if (state is SalmonTheme) {
      return AppTheme.salmonLight;
    } else if (state is SciFiTheme) {
      return AppTheme.sciFiLight;
    } else {
      return AppTheme.classicLight;
    }
  }

  ThemeData getDarkTheme(ThemeState state) {
    if (state is ClassicTheme) {
      return AppTheme.classicDark;
    } else if (state is ElegantTheme) {
      return AppTheme.elegantDark;
    } else if (state is SalmonTheme) {
      return AppTheme.salmonDark;
    } else if (state is SciFiTheme) {
      return AppTheme.sciFiDark;
    } else {
      return AppTheme.classicDark;
    }
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
          create: (context) => sl<AppearanceCubit>()
            ..setAppearanceSystem(), // TODO: switch this eventually for loading from user storage?
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ThemeCubit>()
            ..setThemeClassic(), // TODO: switch this eventually for loading from user storage?
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<BiometricsEnabledCubit>()..loadSetting(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<AppearanceCubit, AppearanceState>(
          builder: (context, appearanceState) {
            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  useInheritedMediaQuery: kPreviewMode,
                  title: "Confesi",
                  onGenerateRoute: appRouter.onGenerateRoute,
                  theme: getLightTheme(themeState),
                  darkTheme: getDarkTheme(themeState),
                  themeMode: getAppearance(appearanceState),
                  builder: DevicePreview.appBuilder,

                  /// Manages navigating to new screens if the authentication state switches to certain values.
                  home: BlocListener<AuthenticationCubit, AuthenticationState>(
                    listenWhen: (previous, current) {
                      return (previous.runtimeType != current.runtimeType) &&
                          previous is! UserError;
                    },
                    listener: (context, state) {
                      if (devMode) {
                        Navigator.of(context).pushNamed("/home");
                        return;
                      }
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
                    child: devMode ? const HomeScreen() : const SplashScreen(),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
