import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/shared/behaviours/init_scale.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../init.dart';
import '../../shared/overlays/text_block_overlay.dart';
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

import '../../shared/overlays/feedback_sheet.dart';
import '../../shared/overlays/notification_chip.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool shakeSheetOpen = false;

  @override
  void initState() {
    manageDynamicLinks();
    manageNotifications();
    loadInAppMessages();
    super.initState();
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
    });
    sl.get<NotificationService>().onMessageOpenedApp((message) {
      sl.get<NotificationService>().fcmDeletagor(
            message: message,
            onNotification: (title, body) =>
                showNotificationChip(context, "$title\n$body", notificationType: NotificationType.success),
            onUpdateMessage: (title, body) => sl.get<InAppMessageService>().addMessage(title, body),
          );
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
        (failure) => showNotificationChip(context, "Error opening dynamic link"),
        (route) {
          print(
              "=====================> Received dynamic link: ${route.routeName()} with id ${(route as PostRoute).postId}");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: InitScale(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Hero(
                  tag: "logo",
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      "assets/images/logos/logo_transparent.png",
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
