import 'package:Confessi/application/authentication/cubit/authentication_cubit.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/overlays/top_chip.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/textfields/bulge.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required this.previousScreen}) : super(key: key);

  final VoidCallback previousScreen;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with AutomaticKeepAliveClientMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
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
              maintainBottomViewPadding: true,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Almost done.",
                                      textStyle:
                                          kSansSerifDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                                      speed: const Duration(
                                        milliseconds: 75,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: heightFactor * 8),
                                Column(
                                  children: [
                                    BulgeTextField(
                                      controller: emailController,
                                      hintText: "Email",
                                      bottomPadding: 10,
                                    ),
                                    BulgeTextField(
                                      controller: usernameController,
                                      hintText: "Username",
                                      bottomPadding: 10,
                                    ),
                                    BulgeTextField(
                                      controller: passwordController,
                                      password: true,
                                      hintText: "Password",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 45),
                                PopButton(
                                  bottomPadding: 15,
                                  loading: state is UserLoading ? true : false,
                                  justText: true,
                                  onPress: () async {
                                    FocusScope.of(context).unfocus();
                                    await context.read<AuthenticationCubit>().registerUser(
                                          usernameController.text,
                                          passwordController.text,
                                          emailController.text,
                                        );
                                  },
                                  icon: CupertinoIcons.chevron_right,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                  text: "Complete Registration",
                                ),
                                TouchableOpacity(
                                  onTap: () => widget.previousScreen(),
                                  child: Container(
                                    // Transparent hitbox trick.
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Go back",
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
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
