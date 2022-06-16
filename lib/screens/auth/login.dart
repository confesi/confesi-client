import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/models/auth/email_login.dart';
import 'package:flutter_mobile_client/models/auth/username_login.dart';
import 'package:flutter_mobile_client/screens/auth/open.dart';
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController errorAnimController;
  TextEditingController usernameEmailController = TextEditingController();
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

  void setError(LoginResponse response) {
    switch (response) {
      case LoginResponse.detailsIncorrect:
        showErrorMessage("Password incorrect.");
        break;
      case LoginResponse.serverError:
        showErrorMessage("Internal server error. Please try again later.");
        break;
      case LoginResponse.accountDoesNotExist:
        showErrorMessage("An account with these credentials doesn't exist.");
        break;
      case LoginResponse.fieldsCannotBeBlank:
        showErrorMessage("Fields cannot be blank.");
        break;
      case LoginResponse.usernameOrEmailTooShort:
        showErrorMessage("Email/username must be at least 3 characters long.");
        break;
      case LoginResponse.passwordTooShort:
        print("SHOWING PW MESSAGE");
        showErrorMessage("Password must be at least 6 characters long.");
        break;
      case LoginResponse.connectionError:
      default:
        showErrorMessage("Connection error.");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TokenState>(tokenProvider, (TokenState? prevState, TokenState newState) {
      print("login LISTENER CALLED");
      // Popup logic from FLAGS.
      if (prevState?.connectionErrorFLAG != newState.connectionErrorFLAG) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Connection Error"),
          ),
        );
      }
      if (prevState?.serverErrorFLAG != newState.serverErrorFLAG) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server Error"),
          ),
        );
      }
      // Screen switching logic.
      if (newState.screen == ScreenState.home) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomNav()),
            (Route<dynamic> route) => false);
      }
    });
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return KeyboardDismissLayout(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
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
                          "Let's log you in.",
                          style: kDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: heightFactor * 8),
                        Column(
                          children: [
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
                            if (usernameEmailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              setError(LoginResponse.fieldsCannotBeBlank);
                            } else if (usernameEmailController.text.length < 3) {
                              setError(LoginResponse.usernameOrEmailTooShort);
                            } else if (passwordController.text.length < 6) {
                              setError(LoginResponse.passwordTooShort);
                            } else {
                              hideErrorMessage();
                              setState(() {
                                isLoading = true;
                              });
                              LoginResponse response = await ref
                                  .read(tokenProvider.notifier)
                                  .login(usernameEmailController.text, passwordController.text);
                              setError(response);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.background,
                          text: "Login",
                        ),
                        Center(
                          child: LinkText(
                              onPress: () {}, linkText: "Tap here.", text: "Forgot password? "),
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
    );
  }
}
