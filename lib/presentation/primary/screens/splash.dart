import '../../../domain/authentication_and_settings/entities/user.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';

import '../../../application/authentication_and_settings/cubit/login_cubit.dart';
import '../../../application/authentication_and_settings/cubit/register_cubit.dart';
import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/generators/intro_text_generator.dart';
import '../../shared/overlays/feedback_sheet.dart';
import '../../../core/alt_unused/notification_chip.dart';
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
      listenWhen: (previous, current) => (previous.runtimeType != current.runtimeType),
      listener: (context, state) {
        if (state is OpenUser) {
          // State is OpenUser, meaning they haven't seen the home screen yet ever.
          print("open user");
          Navigator.of(context).pushNamed("/open");
        } else if (state is User) {
          // State is some subset of User, whether that be Guest or RegisteredUser.
          if (state.userType is RegisteredUser) {
            // State is RegisteredUser, meaning they are a registered user.
            print("registered user");
            Navigator.of(context).pushNamed("/home");
          } else {
            // State is Guest, meaning they are a guest user.
            print("guest");
            Navigator.of(context).pushNamed("/home");
          }
        } else if (state is UserError) {
          // Something went vastly wrong. Push to error screen.
          Navigator.of(context).pushNamed("/prefsError");
        }
      },
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is EnteringRegisterData && state.hasError) {
            showNotificationChip(context, state.errorMessage);
          } else if (state is RegisterSuccess) {
            // context.read<UserCubit>().authenticateUser(AuthenticationType.register); // TODO: fix
          }
        },
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is EnteringLoginData && state.hasError) {
              showNotificationChip(context, state.errorMessage);
            } else if (state is LoginSuccess) {
              // context.read<UserCubit>().authenticateUser(AuthenticationType.login); // TODO: fix
            }
          },
          child: ThemedStatusBar(
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.shadow,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Text(
                    "Confesi",
                    style: kDisplay1.copyWith(
                      fontSize: 34,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
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
