import '../../../core/utils/sizing/height_fraction.dart';
import '../widgets/authentication/item_selector.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/scrollable_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/register_cubit.dart';
import '../../../constants/authentication_and_settings/text.dart';
import '../../../core/styles/typography.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/minimal_appbar.dart';
import '../../shared/text_animations/typewriter.dart';
import '../widgets/authentication/search_items_sheet.dart';

class AccountDetailsTab extends StatefulWidget {
  const AccountDetailsTab({
    Key? key,
    required this.nextScreen,
  }) : super(key: key);

  final VoidCallback nextScreen;

  @override
  State<AccountDetailsTab> createState() => _AccountDetailsTabState();
}

class _AccountDetailsTabState extends State<AccountDetailsTab> with AutomaticKeepAliveClientMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late TypewriterController typewriterController;

  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    typewriterController = TypewriterController(fullText: kAccountDetailsTypewriterText);
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
                child: ScrollableArea(
                  thumbVisible: false,
                  controller: scrollController,
                  keyboardDismiss: true,
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
                                textStyle: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                                controller: typewriterController,
                              ),
                              SizedBox(height: heightFactor * 8),
                              Column(
                                children: [
                                  ItemSelector(
                                    text: kAccountDetailsUniversityFieldLabel,
                                    bottomPadding: 10,
                                    onTap: () => showSearchItemsSheet(context),
                                  ),
                                  ItemSelector(
                                    text: kAccountDetailsYearFieldLabel,
                                    bottomPadding: 10,
                                    onTap: () => print("tap"),
                                  ),
                                  ItemSelector(
                                    text: kAccountDetailsFacultyFieldLabel,
                                    bottomPadding: 10,
                                    onTap: () => print("tap"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 45),
                              BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  return PopButton(
                                    loading: state is RegisterLoading,
                                    justText: true,
                                    onPress: () => widget.nextScreen(),
                                    icon: CupertinoIcons.chevron_right,
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    textColor: Theme.of(context).colorScheme.onSecondary,
                                    text: kAccountDetailsContinueButtonText,
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
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
    );
  }
}
