import '../../../core/utils/sizing/bottom_safe_area.dart';

import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/scrollable_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/register_cubit.dart';
import '../../../constants/authentication_and_settings/text.dart';
import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text_animations/typewriter.dart';
import '../../shared/textfields/bulge.dart';

class RegisterScreenTab extends StatefulWidget {
  const RegisterScreenTab({Key? key, required this.previousScreen}) : super(key: key);

  final VoidCallback previousScreen;

  @override
  State<RegisterScreenTab> createState() => _RegisterScreenTabState();
}

class _RegisterScreenTabState extends State<RegisterScreenTab> with AutomaticKeepAliveClientMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScrollController scrollController;
  late TypewriterController typewriterController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: kRegisterTypewriterText);
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
                  child: ScrollableArea(
                    thumbVisible: false,
                    controller: scrollController,
                    child: SizedBox(
                      height: heightFraction(context, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) {
                              return MinimalAppbarLayout(
                                pressable: state is! RegisterLoading,
                              );
                            },
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
                                      topText: kRegisterEmailFieldLabel,
                                      bottomPadding: 10,
                                    ),
                                    BulgeTextField(
                                      controller: usernameController,
                                      topText: kRegisterUsernameFieldLabel,
                                      bottomPadding: 10,
                                    ),
                                    BulgeTextField(
                                      controller: passwordController,
                                      password: true,
                                      topText: kRegisterPasswordFieldLabel,
                                      bottomPadding: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 45),
                                BlocBuilder<RegisterCubit, RegisterState>(
                                  builder: (context, state) {
                                    return PopButton(
                                      bottomPadding: 15,
                                      loading: state is RegisterLoading,
                                      justText: true,
                                      onPress: () async {
                                        FocusScope.of(context).unfocus();
                                        context.read<RegisterCubit>().page2Submit(
                                            usernameController.text, passwordController.text, emailController.text);
                                      },
                                      icon: CupertinoIcons.chevron_right,
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      textColor: Theme.of(context).colorScheme.onSecondary,
                                      text: kRegisterSubmitButtonText,
                                    );
                                  },
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
                                          kRegisterGoBackButtonText,
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
                                SizedBox(height: bottomSafeArea(context) * 2),
                              ],
                            ),
                          ),
                        ],
                      ),
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
