import 'dart:math';

import 'package:Confessi/application/settings/prefs_cubit.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  @override
  void initState() {
    introText = getIntro().text;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.linear,
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
    await Future.delayed(const Duration(milliseconds: 350));
    _animController.forward().then((value) {
      HapticFeedback.lightImpact();
      _animController.reverse();
    });
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
          if (state.hasRefreshToken) Navigator.of(context).pushNamed("/home");
          if (!state.hasRefreshToken) {
            // FIRST TIME LOGIC
            if (state.hasRefreshToken) Navigator.of(context).pushNamed("/home");
            if (state.hasRefreshToken) Navigator.of(context).pushNamed("/home");
          }
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.classicLight.colorScheme.secondary,
          body: SafeArea(
            child: Center(
              child: ScrollableView(
                child: Transform.scale(
                  scale: (1 + 0.25 * _anim.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: widthBreakpointFraction(context, 1 / 4, 250),
                          child: Text(
                            "Confesi",
                            style: kDisplay.copyWith(
                              color: AppTheme.classicLight.colorScheme.onSecondary,
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
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
