import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../../core/utils/sizing/height_fraction.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../shared/behaviours/nav_blocker.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/text_animations/typewriter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/authentication_and_settings/cubit/login_cubit.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/keyboard_dismiss.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import '../../../shared/buttons/pop.dart';
import '../../../shared/layout/minimal_appbar.dart';
import '../../../shared/textfields/bulge_textfield.dart';
import '../../../shared/textfields/expandable_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  TextEditingController usernameEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScrollController scrollController;
  late TypewriterController typewriterController;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: kLoginTypewriter);
    typewriterController.forward();
    scrollController = ScrollController();
    usernameEmailController.clear();
    passwordController.clear();
    super.initState();
  }

  @override
  void dispose() {
    usernameEmailController.dispose();
    passwordController.dispose();
    scrollController.dispose();
    typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return NavBlocker(
          blocking: state is LoginLoading,
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
                      ),
                      Expanded(
                        child: ScrollableView(
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
                              const SizedBox(height: 15),
                              ExpandableTextfield(
                                maxLines: 1,
                                color: Theme.of(context).colorScheme.background,
                                controller: usernameEmailController,
                                onChanged: (newValue) => print(newValue),
                                hintText: "Username or email",
                              ),
                              const SizedBox(height: 15),
                              ExpandableTextfield(
                                maxLines: 1,
                                color: Theme.of(context).colorScheme.background,
                                controller: passwordController,
                                onChanged: (newValue) => print(newValue),
                                hintText: "Password",
                              ),
                              const SizedBox(height: 30),
                              PopButton(
                                loading: state is LoginLoading, // state is UserLoading ? true : false
                                justText: true,
                                onPress: () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<LoginCubit>()
                                      .loginUser(usernameEmailController.text, passwordController.text);
                                },
                                icon: CupertinoIcons.chevron_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                text: kLoginButtonText,
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
                                          kForgotPasswordText,
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
      },
    );
  }
}
