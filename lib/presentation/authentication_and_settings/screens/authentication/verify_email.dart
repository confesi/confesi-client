import '../../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../../init.dart';
import '../../../shared/behaviours/animated_bobbing.dart';
import '../../../shared/overlays/notification_chip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../../../../core/router/go_router.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/services/user_auth/user_auth_service.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/text_animations/typewriter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import '../../../shared/buttons/pop.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> with TickerProviderStateMixin {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bobbing(
                        child: FractionallySizedBox(
                          widthFactor: 0.15,
                          child: Hero(
                            tag: "logo",
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ShakeWidget(
                                duration: const Duration(milliseconds: 800),
                                shakeConstant: ShakeDefaultConstant1(),
                                autoPlay: context.watch<AuthFlowCubit>().isLoading,
                                child: Image.asset(
                                  "assets/images/logos/logo_transparent.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Please verify your email",
                        style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                          children: [
                            TextSpan(
                              text: "Click the link in the email sent to ",
                              style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            TextSpan(
                              text: sl.get<UserAuthService>().email,
                              style: kBody.copyWith(color: Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                          children: [
                            TextSpan(
                              text: "As a safety precaution, unverified accounts are reset quickly.",
                              style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      AbsorbPointer(
                        absorbing: context.watch<AuthFlowCubit>().isLoading,
                        child: PopButton(
                          loading: context.watch<AuthFlowCubit>().isLoading,
                          justText: true,
                          onPress: () => context.read<AuthFlowCubit>().refreshToken(),
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          text: "I've verified my email",
                        ),
                      ),
                      const SizedBox(height: 15),
                      AbsorbPointer(
                        absorbing: context.watch<AuthFlowCubit>().isLoading,
                        child: PopButton(
                          loading: context.watch<AuthFlowCubit>().isLoading,
                          justText: true,
                          onPress: () async => await context.read<AuthFlowCubit>().sendVerificationEmail(),
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          text: "Resend verification email",
                        ),
                      ),
                      const SizedBox(height: 15),
                      AbsorbPointer(
                        absorbing: context.watch<AuthFlowCubit>().isLoading,
                        child: TouchableOpacity(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            await context.read<AuthFlowCubit>().logout();
                          },
                          child: Container(
                            // Transparent hitbox trick.
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Logout",
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
                      ),
                      SizedBox(height: bottomSafeArea(context)),
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
