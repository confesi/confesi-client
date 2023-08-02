import 'package:provider/provider.dart';


import '../../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../../core/router/go_router.dart';
import '../../../shared/behaviours/nav_blocker.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import '../../../shared/buttons/pop.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/textfields/expandable_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.props});

  final RegistrationPops props;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  late ScrollController scrollController;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode passwordConfirmFocusNode = FocusNode();

  @override
  void initState() {
    scrollController = ScrollController();
    emailFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    passwordConfirmController.dispose();
    passwordController.dispose();
    emailController.dispose();
    scrollController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavBlocker(
      blocking: context.watch<AuthFlowCubit>().isLoading,
      child: ThemeStatusBar(
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
                    centerWidget: Text(
                      widget.props.upgradingToFullAccount ? "Upgrade to Full Account" : "Create Account",
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    leftIconDisabled: context.watch<AuthFlowCubit>().isLoading,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      controller: scrollController,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "We only accept your official school email to ensure you are a student. This is kept private and only used for registration.",
                              style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ExpandableTextfield(
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            autoCorrectAndCaps: false,
                            maxLines: 1,
                            controller: emailController,
                            hintText: "Email",
                          ),
                          const SizedBox(height: 15),
                          ExpandableTextfield(
                            focusNode: passwordFocusNode,
                            autoCorrectAndCaps: false,
                            obscured: true,
                            maxLines: 1,
                            controller: passwordController,
                            hintText: "Password",
                          ),
                          const SizedBox(height: 15),
                          ExpandableTextfield(
                            focusNode: passwordConfirmFocusNode,
                            autoCorrectAndCaps: false,
                            obscured: true,
                            maxLines: 1,
                            controller: passwordConfirmController,
                            hintText: "Confirm password",
                          ),
                          const SizedBox(height: 30),
                          PopButton(
                            loading: context.watch<AuthFlowCubit>().isLoading,
                            justText: true,
                            onPress: () async {
                              FocusScope.of(context).unfocus();
                              await context.read<AuthFlowCubit>().register(
                                    emailController.text,
                                    passwordController.text,
                                    passwordConfirmController.text,
                                    upgradingToFullAcc: widget.props.upgradingToFullAccount,
                                  );
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            icon: CupertinoIcons.chevron_right,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.onSecondary,
                            text: widget.props.upgradingToFullAccount ? "Upgrade" : "Register",
                          ),
                          const SizedBox(height: 15),
                          AbsorbPointer(
                            absorbing: context.watch<AuthFlowCubit>().isLoading,
                            child: TouchableOpacity(
                              onTap: () => router.push("/login"),
                              child: Container(
                                // Transparent hitbox trick.
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Login instead",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
