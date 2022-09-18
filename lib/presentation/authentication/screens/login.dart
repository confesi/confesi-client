import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/overscroll.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text/link.dart';
import '../../shared/textfields/bulge.dart';
import '../cubit/authentication_cubit.dart';
import '../../shared/text/fade_size_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController errorAnimController;
  TextEditingController usernameEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // What to show as error message.
  String errorText = "";

  @override
  void initState() {
    errorAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    errorAnimController.dispose();
    usernameEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showErrorMessage(String textToDisplay) async {
    errorAnimController.reverse().then((value) async {
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
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
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
                            Text(
                              "Let's log you in.",
                              style: kDisplay.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                              textAlign: TextAlign.left,
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
                            FadeSizeText(
                              text: errorText,
                              childController: errorAnimController,
                            ),
                            PopButton(
                              loading: state is UserLoading ? true : false,
                              justText: true,
                              onPress: () async {
                                FocusScope.of(context).unfocus();
                                await context
                                    .read<AuthenticationCubit>()
                                    .loginUser(
                                      usernameEmailController.text,
                                      passwordController.text,
                                    );
                              },
                              icon: CupertinoIcons.chevron_right,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              text: "Login",
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: LinkText(
                                  onPress: () {},
                                  linkText: "Tap here.",
                                  text: "Forgot password? "),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
