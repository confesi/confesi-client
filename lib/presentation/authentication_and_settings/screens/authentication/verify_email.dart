import 'package:confesi/init.dart';
import 'package:confesi/presentation/shared/overlays/notification_chip.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/router/go_router.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../shared/behaviours/nav_blocker.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/text_animations/typewriter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/authentication_and_settings/cubit/login_cubit.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import '../../../shared/buttons/pop.dart';
import '../../../shared/textfields/expandable_textfield.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> with TickerProviderStateMixin {
  late ScrollController scrollController;
  late TypewriterController typewriterController;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: "Please verify your email.");
    typewriterController.forward();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return ThemedStatusBar(
          child: KeyboardDismiss(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).colorScheme.shadow,
              body: SafeArea(
                bottom: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please verify your email.",
                          style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Click the link sent to: me@matthewtrent.me",
                          style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        PopButton(
                          justText: true,
                          onPress: () {
                            if (sl.get<FirebaseAuth>().currentUser != null &&
                                sl.get<FirebaseAuth>().currentUser!.emailVerified) {
                              router.go("/home");
                            } else {
                              showNotificationChip(context, "Not yet verified.");
                            }
                          },
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          text: "I've verified my email",
                        ),
                        const SizedBox(height: 15),
                        PopButton(
                          justText: true,
                          onPress: () {
                            // todo: resend, or error because it's been done too much
                          },
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          text: "Resend verification email",
                        ),
                        const SizedBox(height: 15),
                        TouchableOpacity(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            router.go("/open");
                          },
                          child: Container(
                            // Transparent hitbox trick.
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Go back",
                                    style: kTitle.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
