import '../../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../../init.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scrollable/exports.dart';

import '../../../../core/services/user_auth/user_auth_service.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/behaviours/nav_blocker.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/buttons/pop.dart';
import '../../../shared/textfields/expandable_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with TickerProviderStateMixin {
  late ScrollController scrollController;
  late TextEditingController emailController;
  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    scrollController = ScrollController();
    emailController =
        TextEditingController(text: sl.get<UserAuthService>().email != "" ? sl.get<UserAuthService>().email : null);
    emailFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    scrollController.dispose();
    emailController.dispose();
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
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AppbarLayout(
                    bottomBorder: true,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    centerWidget: Text(
                      "Reset Password",
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    leftIconDisabled: context.watch<AuthFlowCubit>().isLoading,
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.shadow,
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "This will only send if the account exists. You're limited to 3 reset emails per hour. Don't spam.",
                                style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ExpandableTextfield(
                              keyboardType: TextInputType.emailAddress,
                              autoCorrectAndCaps: false,
                              maxLines: 1,
                              focusNode: emailFocusNode,
                              controller: emailController,
                              hintText: "Your account's email",
                            ),
                            const SizedBox(height: 30),
                            PopButton(
                              loading: context.watch<AuthFlowCubit>().isLoading,
                              justText: true,
                              onPress: () async {
                                FocusScope.of(context).unfocus();
                                await context.read<AuthFlowCubit>().sendPasswordResetEmail(emailController.text);
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              icon: CupertinoIcons.chevron_right,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              text: "Send",
                            ),
                          ],
                        ),
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
