import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:scrollable/exports.dart';

import '../../../constants/feedback/text.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/scrollable_area.dart';
import '../../shared/textfields/expandable_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/feedback/general.dart';
import '../../../core/styles/typography.dart';
import '../../shared/other/text_limit_tracker.dart';
import '../../shared/layout/appbar.dart';

class FeedbackHome extends StatefulWidget {
  const FeedbackHome({super.key});

  @override
  State<FeedbackHome> createState() => _FeedbackHomeState();
}

class _FeedbackHomeState extends State<FeedbackHome> {
  late TextEditingController textEditingController;
  final FocusNode textFocusNode = FocusNode();

  bool isTextFocused = false;

  @override
  void initState() {
    textEditingController = TextEditingController();
    textFocusNode.addListener(() {
      if (textFocusNode.hasFocus) {
        isTextFocused = true;
      } else {
        isTextFocused = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: ThemedStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppbarLayout(
                  bottomBorder: false,
                  centerWidget: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isTextFocused
                        ? TextLimitTracker(
                            value: textEditingController.text.length / maxFeedbackTextCharacterLimit,
                          )
                        : Text(
                            pageTitle,
                            style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                  ),
                  leftIcon: CupertinoIcons.xmark,
                ),
                Expanded(
                  child: ScrollableView(
                    scrollBarVisible: false,
                    inlineBottomOrRightPadding: bottomSafeArea(context),
                    controller: ScrollController(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          InitScale(
                            child: ExpandableTextfield(
                              focusNode: textFocusNode,
                              maxLines: 8,
                              maxCharacters: maxFeedbackTextCharacterLimit,
                              hintText: textFieldHint,
                              controller: textEditingController,
                              onChanged: (newValue) {
                                print(newValue);
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          InitScale(
                            child: PopButton(
                              topPadding: 5,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              text: "Submit",
                              onPress: () => print("tap"),
                              icon: CupertinoIcons.up_arrow,
                            ),
                          ),
                        ],
                      ),
                    ),
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
