import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/models/auth/email_login.dart';
import 'package:flutter_mobile_client/models/auth/username_login.dart';
import 'package:flutter_mobile_client/responses/register.dart';
import 'package:flutter_mobile_client/screens/auth/login.dart';
import 'package:flutter_mobile_client/screens/auth/open.dart';
import 'package:flutter_mobile_client/screens/auth/showcase.dart';
import 'package:flutter_mobile_client/screens/start/bottom_nav.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/utils/auth/email_or_username.dart';
import 'package:flutter_mobile_client/widgets/buttons/pop.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/layouts/minimal_appbar.dart';
import 'package:flutter_mobile_client/widgets/text/fade_size.dart';
import 'package:flutter_mobile_client/widgets/text/link.dart';
import 'package:flutter_mobile_client/widgets/textfield/bulge.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController errorAnimController;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // To show spinner on button.
  bool isLoading = false;
  // What to show as error message.
  String errorText = "";

  @override
  void initState() {
    errorAnimController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
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
    ref.listen<TokenState>(tokenProvider, (TokenState? prevState, TokenState newState) {
      // Screen switching logic.
      if (newState.screen == ScreenState.onboarding) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ShowcaseScreen()),
            (Route<dynamic> route) => false);
      }
    });
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return KeyboardDismissLayout(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: CupertinoScrollbar(
            child: ScrollConfiguration(
              behavior: NoOverScrollSplash(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MinimalAppbarLayout(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "Let's get you started.",
                            style: kDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.left,
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
                          FadeSizeText(
                            text: errorText,
                            childController: errorAnimController,
                          ),
                          PopButton(
                            loading: isLoading,
                            justText: true,
                            onPress: () async {
                              FocusScope.of(context).unfocus();
                              RegisterResponse response = localResponses(emailController.text,
                                  usernameController.text, passwordController.text);
                              if (response == RegisterResponse.success) {
                                // now we're doing a server call (passes all local tests)
                                hideErrorMessage();
                                setState(() {
                                  isLoading = true;
                                });
                                response = await ref.read(tokenProvider.notifier).register(
                                    emailController.text,
                                    usernameController.text,
                                    passwordController.text);
                                showErrorMessage(errorMessagesToShow(response));
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                // deal with local error
                                showErrorMessage(errorMessagesToShow(response));
                              }
                            },
                            icon: CupertinoIcons.chevron_right,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.primary,
                            text: "Register",
                          ),
                          Center(
                            child: LinkText(
                                onPress: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                                },
                                linkText: "Tap here.",
                                text: "Already a user? "),
                          ),
                          const SizedBox(height: 10),
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
  }
}