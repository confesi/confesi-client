import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../behaviors/overscroll.dart';
import '../../constants/typography.dart';
import '../../responses/login.dart';
import '../../state/token_slice.dart';
import '../../widgets/buttons/pop.dart';
import '../../widgets/layouts/keyboard_dismiss.dart';
import '../../widgets/layouts/minimal_appbar.dart';
import '../../widgets/text/fade_size.dart';
import '../../widgets/text/link.dart';
import '../../widgets/textfield/bulge.dart';
import '../start/bottom_nav.dart';

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

  @override
  Widget build(BuildContext context) {
    ref.listen<TokenState>(tokenProvider, (TokenState? prevState, TokenState newState) {
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
                              LoginResponse response = localResponses(
                                  usernameEmailController.text, passwordController.text);
                              if (response == LoginResponse.success) {
                                // now we're doing a server call (passes all local tests)
                                hideErrorMessage();
                                setState(() {
                                  isLoading = true;
                                });
                                response = await ref
                                    .read(tokenProvider.notifier)
                                    .login(usernameEmailController.text, passwordController.text);
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
    );
  }
}
