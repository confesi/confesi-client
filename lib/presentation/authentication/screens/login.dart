import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/overlays/top_chip.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/overscroll.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text/link.dart';
import '../../shared/textfields/bulge.dart';
import '../../../application/authentication/cubit/authentication_cubit.dart';
import '../../shared/text/fade_size_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is UserError) showTopChip(context, state.message);
      },
      builder: (context, state) {
        return ThemedStatusBar(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        MinimalAppbarLayout(
                          pressable: state is UserLoading ? false : true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              AnimatedTextKit(
                                displayFullTextOnTap: true,
                                pause: const Duration(milliseconds: 200),
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    "Let's log you in.",
                                    textStyle: kSansSerifDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                                    speed: const Duration(
                                      milliseconds: 75,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: heightFactor * 8),
                              BulgeTextField(
                                controller: usernameEmailController,
                                hintText: "Email or username",
                                bottomPadding: 10,
                              ),
                              BulgeTextField(
                                controller: passwordController,
                                password: true,
                                hintText: "Password",
                              ),
                              const SizedBox(height: 45),
                              PopButton(
                                bottomPadding: 15,
                                loading: state is UserLoading ? true : false,
                                justText: true,
                                onPress: () async {
                                  FocusScope.of(context).unfocus();
                                  await context.read<AuthenticationCubit>().loginUser(
                                        usernameEmailController.text,
                                        passwordController.text,
                                      );
                                },
                                icon: CupertinoIcons.chevron_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                text: "Login",
                              ),
                              TouchableOpacity(
                                onTap: () => {},
                                child: Container(
                                  // Transparent hitbox trick.
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "I forgot my password",
                                        style: kTitle.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
