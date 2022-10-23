import 'package:Confessi/presentation/authentication/widgets/item_selector.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text_animations/typewriter.dart';
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
  late TypewriterController typewriterController;

  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: "Let's get you started.");
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
                              loading: false, // state is UserLoading ? true : false
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
  }
}
