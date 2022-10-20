import 'package:Confessi/application/authentication/cubit/authentication_cubit.dart';
import 'package:Confessi/presentation/authentication/widgets/item_selector.dart';
import 'package:Confessi/presentation/shared/behaviours/keyboard_dismiss.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/overlays/top_chip.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../widgets/search_items_sheet.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({
    Key? key,
    required this.nextScreen,
  }) : super(key: key);

  final VoidCallback nextScreen;

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> with AutomaticKeepAliveClientMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightFactor = MediaQuery.of(context).size.height / 100;
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is UserError) showTopChip(context, state.message);
      },
      builder: (context, state) {
        return ThemedStatusBar(
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
                      keyboardDismiss: true,
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
                                      textStyle:
                                          kSansSerifDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                                      speed: const Duration(
                                        milliseconds: 75,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: heightFactor * 8),
                                Column(
                                  children: [
                                    ItemSelector(
                                      text: "University or college",
                                      bottomPadding: 10,
                                      onTap: () => showSearchItemsSheet(context),
                                    ),
                                    ItemSelector(
                                      text: "Year of study",
                                      bottomPadding: 10,
                                      onTap: () => print("tap"),
                                    ),
                                    ItemSelector(
                                      text: "Faculty (optional)",
                                      bottomPadding: 10,
                                      onTap: () => print("tap"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 45),
                                PopButton(
                                  loading: state is UserLoading ? true : false,
                                  justText: true,
                                  onPress: () async {
                                    widget.nextScreen();
                                    // FocusScope.of(context).unfocus();
                                    // await context.read<AuthenticationCubit>().registerUser(
                                    //       usernameController.text,
                                    //       passwordController.text,
                                    //       emailController.text,
                                    //     );
                                  },
                                  icon: CupertinoIcons.chevron_right,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                  text: "Continue",
                                ),
                                const SizedBox(height: 30),
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
        );
      },
    );
  }
}
