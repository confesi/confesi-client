import 'package:Confessi/application/authentication/authentication_cubit.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text/link.dart';
import '../../shared/textfields/bulge.dart';
import '../../shared/text/fade_size_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late AnimationController errorAnimController;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // What to show as error message.
  String errorText = "";

  @override
  void initState() {
    errorAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    errorAnimController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void showErrorMessage(String textToDisplay) async {
    errorAnimController.reverse().then((value) async {
      // await Future.delayed(const Duration(milliseconds: 200));
      errorText = textToDisplay;
      errorAnimController.forward();
    });
    errorAnimController.addListener(() {
      setState(() {});
    });
  }

  void hideErrorMessage() {
    errorAnimController.reverse();
    errorText = "";
    errorAnimController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is UserError) {
          showErrorMessage(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                                    "Let's get you started.",
                                    textStyle: kDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                                    speed: const Duration(
                                      milliseconds: 100,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: heightFactor * 8),
                              Column(
                                children: [
                                  InitScale(
                                    child: BulgeTextField(
                                      controller: emailController,
                                      hintText: "Email",
                                      bottomPadding: 10,
                                    ),
                                  ),
                                  InitScale(
                                    child: BulgeTextField(
                                      controller: usernameController,
                                      hintText: "Username",
                                      bottomPadding: 10,
                                    ),
                                  ),
                                  InitScale(
                                    child: BulgeTextField(
                                      controller: passwordController,
                                      password: true,
                                      hintText: "Password",
                                    ),
                                  ),
                                ],
                              ),
                              FadeSizeText(
                                text: errorText,
                                childController: errorAnimController,
                              ),
                              PopButton(
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
                                text: "Register",
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: InitTransform(
                                  child: LinkText(
                                    pressable: state is UserLoading ? false : true,
                                    onPress: () {
                                      Navigator.of(context).pushNamed("/login");
                                    },
                                    linkText: "Tap here.",
                                    text: "Already a user? ",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
        );
      },
    );
  }
}
