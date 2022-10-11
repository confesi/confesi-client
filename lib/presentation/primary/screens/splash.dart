import 'dart:math';

import 'package:Confessi/application/authentication/authentication_cubit.dart';
import 'package:Confessi/application/shared/prefs_cubit.dart';
import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
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
  late AnimationController _animController;
  late Animation _anim;
  late String introText;

  // When prefs are loaded.
  bool prefsLoaded = false;

  @override
  void initState() {
    introText = getIntro().text;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    startAnim();
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

  void startAnim() async {
    _animController.forward().then((value) => HapticFeedback.lightImpact());
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: AppTheme.classicLight.colorScheme.secondary,
            body: SafeArea(
              child: Center(
                child: ScrollableView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Transform.scale(
                          scale: _anim.value,
                          child: Column(
                            children: [
                              Transform.translate(
                                offset: Offset(0, (200 - (200 * _anim.value)).toDouble()),
                                child: Transform.rotate(
                                  angle: (2 * pi) - _anim.value * (2 * pi),
                                  child: SizedBox(
                                    height: widthBreakpointFraction(context, .5, 250),
                                    child: Image.asset(
                                      "assets/images/logo2.png",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: heightFraction(context, .3),
                        ),
                        SizedBox(
                          width: widthBreakpointFraction(context, 1 / 4, 250),
                          child: Text(
                            introText,
                            style: kBody.copyWith(
                              color: AppTheme.classicLight.colorScheme.onSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
