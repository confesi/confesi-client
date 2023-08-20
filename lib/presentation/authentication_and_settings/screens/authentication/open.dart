import 'package:flutter/services.dart';

import '../../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../../constants/shared/constants.dart';
import '../../../../core/router/go_router.dart';
import '../../../../core/utils/sizing/width_fraction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/sizing/height_fraction.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/buttons/pop.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  final ValueNotifier<bool> _animationNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _animationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: ThemeStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: SafeArea(
            bottom: false,
            maintainBottomViewPadding: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: heightFraction(context, 1 / 10)),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _animationNotifier.value = !_animationNotifier.value;
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _animationNotifier,
                        builder: (context, trigger, __) {
                          return TweenAnimationBuilder<double>(
                            key: ValueKey(trigger),
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0, end: 1),
                            curve: Curves.bounceOut,
                            builder: (BuildContext context, double value, Widget? child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Image.asset(walrusFullBodyImgPath),
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopButton(
                    onPress: () async => context.read<AuthFlowCubit>().registerAnon(),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    text: "Try as guest",
                    bottomPadding: 5,
                    loading: context.watch<AuthFlowCubit>().isLoading,
                  ),
                  AbsorbPointer(
                    absorbing: context.watch<AuthFlowCubit>().isLoading,
                    child: PopButton(
                      onPress: () => router.push("/login"),
                      icon: CupertinoIcons.arrow_right,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      text: "Login",
                      bottomPadding: 30,
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: context.watch<AuthFlowCubit>().isLoading,
                    child: PopButton(
                      onPress: () => router.push("/register", extra: const RegistrationPops(false)),
                      icon: CupertinoIcons.arrow_right,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onSecondary,
                      text: "Create account",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
