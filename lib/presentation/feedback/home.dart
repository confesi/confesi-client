import 'package:Confessi/core/constants/feedback/text.dart';
import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/keyboard_dismiss.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/textfields/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/feedback/constants.dart';
import '../../core/styles/typography.dart';
import '../shared/other/text_limit_tracker.dart';
import '../shared/layout/appbar.dart';

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
    return KeyboardDismissLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                bottomBorder: false,
                centerWidget: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isTextFocused
                      ? TextLimitTracker(
                          value: textEditingController.text.length /
                              maxFeedbackTextCharacterLimit,
                        )
                      : Text(
                          pageTitle,
                          style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                ),
                leftIcon: CupertinoIcons.xmark,
              ),
              Expanded(
                child: ScrollableView(
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
                            setState(() {});
                          },
                        ),
                      ),
                      InitScale(
                        child: SimpleTextButton(
                          secondaryColors: true,
                          tapType: TapType.lightImpact,
                          horizontalPadding: 10,
                          infiniteWidth: true,
                          onTap: () => print("tap"),
                          text: submitButtonText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
