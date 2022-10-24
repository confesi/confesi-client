import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

import '../../../application/authentication_and_prefs/cubit/login_cubit.dart';
import '../../../application/authentication_and_prefs/cubit/register_cubit.dart';
import '../../../application/authentication_and_prefs/cubit/user_cubit.dart';
import '../../../core/generators/intro_text_generator.dart';
import '../../../core/styles/themes.dart';
import '../../../core/utils/sizing/width_breakpoint_fraction.dart';
import '../../shared/overlays/feedback_sheet.dart';
import '../../shared/overlays/bottom_chip.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool shakeSheetOpen = false;
  late String introText;

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
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) => (previous.runtimeType != current.runtimeType || current is NoUser),
      listener: (context, state) {
        if (state is User) {
          if (state.justRegistered) {
            Navigator.of(context).pushNamed("/onboarding", arguments: {"isRewatching": false});
          } else {
            Navigator.of(context).pushNamed("/home");
          }
        } else if (state is NoUser) {
          Navigator.of(context).pushNamed("/open");
        } else if (state is LocalDataError) {
          Navigator.of(context).pushNamed("/prefsError");
        }
      },
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is EnteringRegisterData && state.hasError) {
            showBottomChip(context, state.errorMessage);
          } else if (state is RegisterSuccess) {
            context.read<UserCubit>().silentlyAuthenticateUser(AuthenticationType.register);
          }
        },
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is EnteringLoginData && state.hasError) {
              showBottomChip(context, state.errorMessage);
            } else if (state is LoginSuccess) {
              context.read<UserCubit>().silentlyAuthenticateUser(AuthenticationType.login);
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
                    height: widthBreakpointFraction(context, .25, 150),
                    child: Image.asset(
                      "assets/images/logo.jpg",
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
