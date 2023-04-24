import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/dependency_injection.dart';
import 'package:Confessi/presentation/shared/overlays/text_block_overlay.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../../constants/shared/dev.dart';
import '../../../core/results/failures.dart';
import '../../../core/services/deep_links.dart';
import '../../../core/services/in_app_notifications/in_app_notifications.dart';
import '../../../core/services/notifications.dart';
import '../../../domain/authentication_and_settings/entities/user.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
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

  bool shouldOpenFeedbackSheetOnShake(BuildContext context) {
    UserCubit userCubit = context.read<UserCubit>();
    return userCubit.stateIsUser && userCubit.stateAsUser.shakeForFeedbackEnum == ShakeForFeedbackEnum.enabled;
  }

  @override
  void initState() {
    manageDynamicLinks();
    manageNotifications();
    loadInAppMessages();
    startShakeListener();
    super.initState();
  }

  // Opens the feedback sheet when the phone is shook. Implemented on the [Splash] screen because it is only shown once per app run. Otherwise, mutliple shake listeners would be created.
  void startShakeListener() {
    ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!shakeSheetOpen && shouldOpenFeedbackSheetOnShake(context)) {
          shakeSheetOpen = true;
          showFeedbackSheet(context).whenComplete(() => shakeSheetOpen = false);
        }
      },
      shakeThresholdGravity: 3,
      shakeCountResetTime: 1500,
      minimumShakeCount: 2,
    );
  }

  Future<void> loadInAppMessages() async {
    (await sl.get<InAppMessageService>().getAllMessages()).fold(
      (failure) => showNotificationChip(context, "Failed to retrieve update messages from server."),
      (messages) => messages.isEmpty
          ? null
          : showTextBlock(
              context,
              messages
                  .map(
                    (e) => UpdateMessage(title: e.title, body: e.content, id: e.id, date: e.date),
                  )
                  .toList(),
            ),
    );
  }

  void manageNotifications() {
    sl.get<NotificationService>().onMessage((message) {
      sl.get<NotificationService>().fcmDeletagor(
            message: message,
            onNotification: (title, body) =>
                showNotificationChip(context, "$title\n$body", notificationType: NotificationType.success),
            onUpdateMessage: (title, body) => sl.get<InAppMessageService>().addMessage(title, body),
          );
      print("======================> Message received in app: ${message.notification?.body}");
    });
    sl.get<NotificationService>().onMessageOpenedApp((message) {
      sl.get<NotificationService>().fcmDeletagor(
            message: message,
            onNotification: (title, body) =>
                showNotificationChip(context, "$title\n$body", notificationType: NotificationType.success),
            onUpdateMessage: (title, body) => sl.get<InAppMessageService>().addMessage(title, body),
          );
      print("======================> Message opened app: ${message.notification?.body}");
    });
  }

  @override
  void dispose() {
    sl.get<DeepLinkStream>().dispose();
    sl.get<NotificationService>().dispose();
    sl.get<InAppMessageService>().dispose();
    super.dispose();
  }

  void manageDynamicLinks() {
    sl.get<DeepLinkStream>().listen((dartz.Either<Failure, DeepLinkRoute> link) {
      link.fold(
        (failure) {
          print("===================> ERROR LINK");
        },
        (route) {
          print(
              "=====================> Received dynamic link: ${route.routeName()} with id ${(route as PostRoute).postId}");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (kJumpToHomeScreen) {
          Navigator.of(context).pushNamed("/home");
          return;
        }
        if (state is User) {
          // State is some subset of User, whether that be Guest or RegisteredUser.
          if (state.userType is RegisteredUser) {
            // State is RegisteredUser, meaning they are a registered user.
            Navigator.of(context).pushNamed("/home");
          } else if (state.userType is Guest) {
            // Go directly to home
            if ((state.userType as Guest).directToHome) {
              Navigator.of(context).pushNamed("/home");
            } else {
              // Go directly to open
              Navigator.of(context).pushNamed("/open");
            }
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
                    style: kSplashScreenLogo.copyWith(
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
