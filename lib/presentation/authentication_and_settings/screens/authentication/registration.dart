import '../../../../application/authentication_and_settings/cubit/register_cubit.dart';
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
import '../../../shared/text_animations/typewriter.dart';
import '../../../shared/textfields/expandable_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScrollController scrollController;
  late TypewriterController typewriterController;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: "Let's get you started.");
    typewriterController.forward();
    scrollController = ScrollController();
    passwordController.clear();
    emailController.clear();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    scrollController.dispose();
    typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return NavBlocker(
          blocking: state is RegisterLoading,
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
                              const SizedBox(height: 30),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "We only accept school emails to ensure you are a student. These are kept private.",
                                  style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ExpandableTextfield(
                                maxLines: 1,
                                color: Theme.of(context).colorScheme.background,
                                controller: emailController,
                                onChanged: (newValue) => print(newValue),
                                hintText: "Email",
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
                                loading: state is RegisterLoading, // state is UserLoading ? true : false
                                justText: true,
                                onPress: () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<RegisterCubit>()
                                      .registerUser(passwordController.text, emailController.text);
                                },
                                icon: CupertinoIcons.chevron_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                text: "Complete registration",
                              ),
                              const SizedBox(height: 15),
                              TouchableOpacity(
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
