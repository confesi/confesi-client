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
import 'package:flutter_mobile_client/widgets/text/link.dart';
import 'package:flutter_mobile_client/widgets/textfield/bulge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController usernameEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
                              hintText: "email or username",
                              bottomPadding: 10,
                            ),
                            BulgeTextField(
                              controller: passwordController,
                              password: true,
                              hintText: "password",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        PopButton(
                          loading: isLoading,
                          justText: true,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            await ref
                                .read(tokenProvider.notifier)
                                .login(usernameEmailController.text, passwordController.text);
                            setState(() {
                              isLoading = false;
                            });
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
