import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/presentation/shared/behaviours/nav_blocker.dart';

import '../../../core/router/go_router.dart';
import '../../../init.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';

import '../../../core/utils/sizing/width_fraction.dart';
import '../../../domain/create_post/entities/draft_post_entity.dart';
import '../../shared/other/widget_or_nothing.dart';
import '../../shared/overlays/notification_chip.dart';
import 'package:scrollable/exports.dart';

import '../../../constants/shared/enums.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/other/text_limit_tracker.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/create_post/general.dart';
import '../../../core/services/create_post_hint_text/create_post_hint_text.dart';
import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/layout/scrollable_area.dart';

// TODO: move to feature constants file and document?
enum FocusedField {
  title,
  body,
  none,
}

class CreatePostHome extends StatefulWidget {
  const CreatePostHome({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePostHome> createState() => _CreatePostHomeState();
}

class _CreatePostHomeState extends State<CreatePostHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController scrollController = ScrollController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode bodyFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  FocusedField focusedField = FocusedField.none;

  void setNoFocus() => setState(() => focusedField = FocusedField.none);

  void setFocus(FocusedField focus) => setState(() => focusedField = focus);

  double getLimitPercent() {
    if (focusedField == FocusedField.title) {
      return titleController.text.runes.length / kPostTitleMaxLength;
    } else if (focusedField == FocusedField.body) {
      return bodyController.text.runes.length / kPostTextMaxLength;
    } else {
      // Case for when [focusedField] is [FocusedField.none]
      return 0;
    }
  }

  late String titleHint;
  late String bodyHint;
  // preload for the drafts sheet
  List<DraftPostEntity> draftEntities = [];

  @override
  void initState() {
    HintText hintText = sl.get<CreatePostHintManager>().getHint();
    titleHint = hintText.title;
    bodyHint = hintText.body;
    titleFocusNode.addListener(() {
      setNoFocus();
      if (titleFocusNode.hasFocus) setFocus(FocusedField.title);
    });
    bodyFocusNode.addListener(() {
      setNoFocus();
      if (bodyFocusNode.hasFocus) setFocus(FocusedField.body);
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    titleFocusNode.dispose();
    bodyFocusNode.dispose();
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  bool isEmpty() => titleController.text.trim().isEmpty && bodyController.text.trim().isEmpty;

  void clearTextfields() {
    titleController.clear();
    bodyController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: NavBlocker(
        blocking: true,
        child: ThemeStatusBar(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AppbarLayout(
                    bottomBorder: false,
                    centerWidget: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: focusedField != FocusedField.none
                          ? SizedBox(
                              width: widthFraction(context, 1),
                              child: Center(child: TextLimitTracker(value: getLimitPercent())))
                          : Text(
                              'Confess Anonymously',
                              style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                    ),
                    rightIconVisible: true,
                    rightIcon: CupertinoIcons.arrow_right,
                    rightIconOnPress: () {
                      if (titleController.text.trim().isEmpty && bodyController.text.trim().isEmpty) {
                        showNotificationChip(context, "You can't post... nothing!");
                        return;
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                      router.push("/create/details");
                      FocusScope.of(context).unfocus();
                    },
                    leftIconVisible: true,
                    leftIcon: CupertinoIcons.xmark,
                    leftIconOnPress: () {
                      isEmpty()
                          ? Navigator.pop(context)
                          : showButtonOptionsSheet(
                              context,
                              [
                                OptionButton(
                                  popContext: false,
                                  onTap: () {
                                    clearTextfields();
                                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                                  },
                                  text: "Discard",
                                  icon: CupertinoIcons.trash,
                                ),
                                OptionButton(
                                  onTap: () {
                                    print('save draft'); // todo
                                  },
                                  text: "Save draft",
                                  icon: CupertinoIcons.tray_arrow_down,
                                ),
                              ],
                            );
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Column(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return KeyboardDismiss(
                                  child: GestureDetector(
                                    onTap: () => bodyFocusNode.requestFocus(),
                                    child: SizedBox(
                                      height: constraints.maxHeight,
                                      child: ScrollableArea(
                                        physics: const ClampingScrollPhysics(),
                                        controller: scrollController,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Transparent hitbox trick.
                                              Container(
                                                height: 20,
                                                color: Colors.transparent,
                                              ),
                                              Container(
                                                // Transparent hitbox trick.
                                                color: Colors.transparent,
                                                child: TextField(
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(kPostTitleMaxLength),
                                                  ],
                                                  onChanged: (value) {
                                                    context.read<PostCategoriesCubit>().updateTitle(value);
                                                    titleController.text = value;
                                                    titleController.selection = TextSelection.fromPosition(
                                                      TextPosition(offset: titleController.text.length),
                                                    );
                                                    setState(() {});
                                                  },
                                                  controller: titleController,
                                                  focusNode: titleFocusNode,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  style:
                                                      kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                                                  decoration: InputDecoration(
                                                    isCollapsed: true,
                                                    border: InputBorder.none,
                                                    hintMaxLines: 3,
                                                    hintText: titleHint,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => titleFocusNode.requestFocus(),
                                                child: Container(
                                                  // Transparent hitbox trick.
                                                  color: Colors.transparent,
                                                  width: double.infinity,
                                                  child: const SizedBox(height: 15),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => bodyFocusNode.requestFocus(),
                                                child: Container(
                                                  // Transparent hitbox trick.
                                                  color: Colors.transparent,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      context.read<PostCategoriesCubit>().updateBody(value);
                                                      bodyController.text = value;
                                                      bodyController.selection = TextSelection.fromPosition(
                                                        TextPosition(offset: bodyController.text.length),
                                                      );
                                                      setState(() {});
                                                    },
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(kPostTextMaxLength),
                                                    ],
                                                    controller: bodyController,
                                                    focusNode: bodyFocusNode,
                                                    textCapitalization: TextCapitalization.sentences,
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: null,
                                                    style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                                                    decoration: InputDecoration(
                                                      isCollapsed: true,
                                                      border: InputBorder.none,
                                                      hintMaxLines: 3,
                                                      hintText: bodyHint,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 30,
                                              ), // Adds some padding to the bottom.
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          WidgetOrNothing(
                            animatedTransition: false,
                            showWidget: titleController.text.isEmpty &&
                                bodyController.text.isEmpty &&
                                !titleFocusNode.hasFocus &&
                                !bodyFocusNode.hasFocus,
                            child: GestureDetector(
                              onTap: () => bodyFocusNode.requestFocus(),
                              child: Container(
                                // Transparent hitbox trick
                                color: Colors.transparent,
                                child: SafeArea(
                                  top: false,
                                  child: Container(
                                    // Transparent hitbox trick
                                    color: Colors.transparent,
                                    width: double.infinity,
                                    child: Center(
                                      child: TouchableScale(
                                        tapType: TapType.lightImpact,
                                        onTap: () => {}, // todo
                                        child: Container(
                                          constraints: BoxConstraints(maxWidth: widthFraction(context, 2 / 3)),
                                          padding: const EdgeInsets.all(20),
                                          margin: const EdgeInsets.symmetric(vertical: 45),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.secondary,
                                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                                          ),
                                          child: Text(
                                            "Load a draft",
                                            style: kTitle.copyWith(
                                              color: Theme.of(context).colorScheme.onSecondary,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
