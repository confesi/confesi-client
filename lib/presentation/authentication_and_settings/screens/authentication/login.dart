import 'package:confesi/application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import 'package:confesi/core/results/failures.dart';

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

import '../../../../core/styles/typography.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import '../../../shared/buttons/pop.dart';
import '../../../shared/textfields/expandable_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScrollController scrollController;
  late TypewriterController typewriterController;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: "Let's log you in.");
    typewriterController.forward();
    scrollController = ScrollController();
    emailController.clear();
    passwordController.clear();
    context.read<AuthFlowCubit>().setEmptyFields();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    scrollController.dispose();
    typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavBlocker(
      blocking: context.watch<AuthFlowCubit>().isLoading,
      child: ThemedStatusBar(
        child: KeyboardDismiss(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).colorScheme.shadow,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AppbarLayout(
                    backgroundColor: Theme.of(context).colorScheme.shadow,
                    centerWidget: Container(),
                    leftIconDisabled: context.watch<AuthFlowCubit>().isLoading,
                  ),
                  Expanded(
                    child: ScrollableView(
                      physics: const BouncingScrollPhysics(),
                      inlineBottomOrRightPadding: bottomSafeArea(context),
                      scrollBarVisible: false,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      controller: ScrollController(),
                      hapticsEnabled: false,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          TypewriterText(
                            textStyle: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                            controller: typewriterController,
                          ),
                          const SizedBox(height: 30),
                          ExpandableTextfield(
                            autoCorrectAndCaps: false,
                            maxLines: 1,
                            controller: emailController,
                            onChanged: (newValue) => print(newValue),
                            hintText: "Email",
                          ),
                          const SizedBox(height: 15),
                          ExpandableTextfield(
                            autoCorrectAndCaps: false,
                            obscured: true,
                            maxLines: 1,
                            controller: passwordController,
                            onChanged: (newValue) => print(newValue),
                            hintText: "Password",
                          ),
                          const SizedBox(height: 30),
                          PopButton(
                            loading: context.watch<AuthFlowCubit>().isLoading,
                            justText: true,
                            onPress: () {
                              FocusScope.of(context).unfocus();
                              context.read<AuthFlowCubit>().login(emailController.text, passwordController.text);
                            },
                            icon: CupertinoIcons.chevron_right,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.onSecondary,
                            text: "Login",
                          ),
                          const SizedBox(height: 15),
                          TouchableOpacity(
                            onTap: () => print("tap"), // TODO: Implement
                            child: Container(
                              // Transparent hitbox trick.
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Forget your password?",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
