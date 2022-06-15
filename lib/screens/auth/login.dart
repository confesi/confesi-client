import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/auth/showcase.dart';
import 'package:flutter_mobile_client/widgets/buttons/pop.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/layouts/minimal_appbar.dart';
import 'package:flutter_mobile_client/widgets/textfield/bulge.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return KeyboardDismissLayout(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
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
                        children: const [
                          BulgeTextField(
                            hintText: "email or username",
                            bottomPadding: 10,
                          ),
                          BulgeTextField(
                            hintText: "password",
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      PopButton(
                        justText: true,
                        onPress: () {},
                        icon: CupertinoIcons.chevron_right,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.background,
                        text: "Create new account",
                        bottomPadding: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
