import 'package:Confessi/application/authentication/cubit/login_cubit.dart';
import 'package:Confessi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text_animations/typewriter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/textfields/bulge.dart';

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
    typewriterController = TypewriterController(fullText: "Let's log you in.");
    typewriterController.forward();
    scrollController = ScrollController();
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
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return NavBlocker(
          blocking: state is LoginLoading,
          child: ThemedStatusBar(
            child: KeyboardDismissLayout(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: ScrollableView(
                    thumbVisible: false,
                    controller: scrollController,
                    child: Column(
                      children: [
                        MinimalAppbarLayout(
                          pressable: state is! LoginLoading, // state is UserLoading ? false : true
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              TypewriterText(
                                textStyle: kSansSerifDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                                controller: typewriterController,
                              ),
                              SizedBox(height: heightFactor * 8),
                              BulgeTextField(
                                controller: usernameEmailController,
                                topText: "Email or username",
                                bottomPadding: 10,
                              ),
                              BulgeTextField(
                                controller: passwordController,
                                password: true,
                                topText: "Password",
                                bottomPadding: 10,
                              ),
                              const SizedBox(height: 45),
                              PopButton(
                                bottomPadding: 15,
                                loading: state is LoginLoading, // state is UserLoading ? true : false
                                justText: true,
                                onPress: () async {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<LoginCubit>()
                                      .loginUser(usernameEmailController.text, passwordController.text);
                                },
                                icon: CupertinoIcons.chevron_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                text: "Login",
                              ),
                              TouchableOpacity(
                                onTap: () => {}, // TODO: Implement
                                child: Container(
                                  // Transparent hitbox trick.
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "I forgot my password",
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
                              const SizedBox(height: 15),
                            ],
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
