import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

import '../../../application/authentication_and_settings/cubit/login_cubit.dart';
import '../../../application/authentication_and_settings/cubit/register_cubit.dart';
import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/generators/intro_text_generator.dart';
import '../../shared/overlays/feedback_sheet.dart';
import '../../shared/overlays/notification_chip.dart';

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
        // if (state is User) {
        //   if (state.justRegistered) {
        //     Navigator.of(context).pushNamed("/onboarding", arguments: {"isRewatching": false});
        //   } else {
        //     Navigator.of(context).pushNamed("/home");
        //   }
        // } else if (state is NoUser) {
        //   Navigator.of(context).pushNamed("/open");
        // } else if (state is LocalDataError) {
        //   Navigator.of(context).pushNamed("/prefsError");
        // }
        Navigator.of(context)
            .pushNamed("/home"); // TODO: Delete this line, and uncomment lines above; this is only for dev mode
      },
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is EnteringRegisterData && state.hasError) {
            showNotificationChip(context, state.errorMessage);
          } else if (state is RegisterSuccess) {
            context.read<UserCubit>().silentlyAuthenticateUser(AuthenticationType.register);
          }
        },
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is EnteringLoginData && state.hasError) {
              showNotificationChip(context, state.errorMessage);
            } else if (state is LoginSuccess) {
              context.read<UserCubit>().silentlyAuthenticateUser(AuthenticationType.login);
            }
          },
          child: ThemedStatusBar(
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: widthFraction(context, .50),
                        child: Image.asset(
                          "assets/images/logo.jpg",
                        ),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: widthFraction(context, .75),
                        child: Text(
                          introText,
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
