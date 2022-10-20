import 'dart:math';

import 'package:Confessi/application/authentication/cubit/authentication_cubit.dart';
import 'package:Confessi/application/shared/cubit/prefs_cubit.dart';
import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

import '../../../core/generators/intro_text_generator.dart';
import '../../../core/styles/themes.dart';
import '../../../core/utils/sizing/width_breakpoint_fraction.dart';
import '../../shared/layout/scrollable_view.dart';
import '../../shared/overlays/feedback_sheet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool shakeSheetOpen = false;
  late String introText;

  // When prefs are loaded.
  bool prefsLoaded = false;

  @override
  void initState() {
    introText = getIntro().text;

    // Opens the feedback sheet when the phone is shook. Implemented on the [Splash] screen because it is only shown once per app run. Otherwise, mutliple shake listeners would be created.
    ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!shakeSheetOpen) {
          shakeSheetOpen = true;
          showFeedbackSheet(context).whenComplete(() => shakeSheetOpen = false);
        }
      },
      shakeThresholdGravity: 3,
      shakeCountResetTime: 1000,
      minimumShakeCount: 3,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrefsCubit, PrefsState>(
      listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state is PrefsError) Navigator.of(context).pushNamed("/prefsError");
        if (state is PrefsLoaded) {
          prefsLoaded = true;
          if (state.refreshTokenEnum == RefreshTokenEnum.hasRefreshToken) {
            Navigator.of(context).pushNamed("/home");
          } else {
            if (state.firstTimeEnum == FirstTimeEnum.firstTime) Navigator.of(context).pushNamed("/onboarding");
            if (state.firstTimeEnum == FirstTimeEnum.notFirstTime) Navigator.of(context).pushNamed("/open");
          }
        }
      },
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (previous, current) {
          return (previous.runtimeType != current.runtimeType) && previous is! UserError && prefsLoaded;
        },
        listener: (context, state) {
          if (state is NoUser) {
            Navigator.of(context).pushNamed("/open");
          } else if (state is User) {
            if (state.justRegistered) Navigator.of(context).pushNamed("/onboardingDetails");
            if (!state.justRegistered) Navigator.of(context).pushNamed("/home");
          }
        },
        child: OneThemeStatusBar(
          brightness: Brightness.light,
          child: Scaffold(
            backgroundColor: AppTheme.classicLight.colorScheme.background,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: SizedBox(
                  height: widthBreakpointFraction(context, .5, 250),
                  child: Image.asset(
                    "assets/images/logo.jpg",
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
