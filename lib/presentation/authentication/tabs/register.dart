import 'package:Confessi/application/authentication/cubit/register_cubit.dart';
import 'package:Confessi/presentation/shared/behaviours/keyboard_dismiss.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text_animations/typewriter.dart';
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
  late ScrollController scrollController;
  late TypewriterController typewriterController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: "Almost done.");
    scrollController = ScrollController();
    typewriterController.forward();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    scrollController.dispose();
    typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return ThemedStatusBar(
      child: KeyboardDismissLayout(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: ScrollableView(
                    thumbVisible: false,
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MinimalAppbarLayout(
                          pressable: true, // state is UserLoading ? false : true
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
                              Column(
                                children: [
                                  BulgeTextField(
                                    controller: emailController,
                                    topText: "Email",
                                    bottomPadding: 10,
                                  ),
                                  BulgeTextField(
                                    controller: usernameController,
                                    topText: "Username",
                                    bottomPadding: 10,
                                  ),
                                  BulgeTextField(
                                    controller: passwordController,
                                    password: true,
                                    topText: "Password",
                                    bottomPadding: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 45),
                              PopButton(
                                bottomPadding: 15,
                                loading: false, // state is UserLoading ? true : false
                                justText: true,
                                onPress: () async {
                                  FocusScope.of(context).unfocus();
                                  context.read<RegisterCubit>().registerUser(
                                      usernameController.text, passwordController.text, emailController.text);
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
      ),
    );
  }
}
