import 'dart:math';

import 'package:Confessi/constants/shared/dev.dart';
import 'package:Confessi/core/curves/bounce_back.dart';
import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/utils/sizing/width_breakpoint_fraction.dart';
import 'package:Confessi/application/authentication/authentication_cubit.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

import '../../../application/settings/prefs_cubit.dart';
import '../../../core/generators/intro_text_generator.dart';
import '../../../core/styles/typography.dart';
import '../../shared/overlays/feedback_sheet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
      duration: const Duration(milliseconds: 200),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
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
    _animController.forward();
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
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (previous, current) {
        return (previous.runtimeType != current.runtimeType) && previous is! UserError;
      },
      listener: (context, authState) {
        // if (!context.read<PrefsCubit>().isLoaded) {
        //   Navigator.of(context).pushNamed("/prefsError");
        // }
        if (authState is NoUser) {
          Navigator.of(context).pushNamed("/open");
        } else if (authState is User) {
          if (authState.justRegistered) {
            Navigator.of(context).pushNamed("/onboarding");
          } else {
            Navigator.of(context).pushNamed("/home");
          }
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.classicLight.colorScheme.secondary,
          body: SafeArea(
            child: Opacity(
              opacity: pow(_anim.value, 2).toDouble(),
              child: Transform.scale(
                scale: (_anim.value).toDouble(),
                child: Center(
                  child: ScrollableView(
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
      ),
    );
  }
}
