import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/models/auth/email_login.dart';
import 'package:flutter_mobile_client/models/auth/username_login.dart';
import 'package:flutter_mobile_client/screens/start/bottom_nav.dart';
import 'package:flutter_mobile_client/utils/auth/email_or_username.dart';
import 'package:flutter_mobile_client/widgets/buttons/pop.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/layouts/minimal_appbar.dart';
import 'package:flutter_mobile_client/widgets/text/link.dart';
import 'package:flutter_mobile_client/widgets/textfield/bulge.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool absorbNavigation = false;
  bool loading = false;

  void loginUser() async {
    setState(() {
      absorbNavigation = true;
      loading = true;
    });
    dynamic user;
    LoginType loginType = usernameOrEmail(usernameEmailController.value.text);
    if (loginType == LoginType.email) {
      // send login with email
      user = EmailLogin(
          email: usernameEmailController.value.text, password: passwordController.value.text);
    } else {
      // send login with username
      user = UsernameLogin(
          username: usernameEmailController.value.text, password: passwordController.value.text);
    }
    // send post to backend with `user` object
    var url = Uri.parse("$kDomain/api/user/login");
    await http.post(url, body: user.toJson()).then((response) {
      setState(() {
        loading = false;
        absorbNavigation = false;
      });
      if (response.statusCode == 200) {
        final String accessToken = json.decode(response.body)["accessToken"];
        print("ACCESS TOKEN GOT FROM LOGIN: $accessToken");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const BottomNav()));
      } else {
        print("ERROR CAUGHT FROM LOGIN ATTEMPT");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return WillPopScope(
      onWillPop: () async => !absorbNavigation,
      child: IgnorePointer(
        ignoring: absorbNavigation,
        child: KeyboardDismissLayout(
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
                              style:
                                  kDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
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
                              loading: loading,
                              justText: true,
                              onPress: () => loginUser(),
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
        ),
      ),
    );
  }
}
