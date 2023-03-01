import 'package:Confessi/application/authentication_and_settings/cubit/user_cubit.dart';
import 'package:Confessi/application/create_post/cubit/drafts_cubit.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/create_post/overlays/drafts_sheet.dart';
import 'package:Confessi/presentation/feed/widgets/child_post.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/other/widget_or_nothing.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:scrollable/exports.dart';

import '../../../application/create_post/cubit/post_cubit.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/other/text_limit_tracker.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/create_post/general.dart';
import '../../../core/generators/hint_text_generator.dart';
import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/layout/scrollable_area.dart';
import '../../shared/overlays/center_overlay_message.dart';
import '../../shared/overlays/info_sheet.dart';

// TODO: move to feature constants file and document?
enum FocusedField {
  title,
  body,
  none,
}

class CreatePostHome extends StatefulWidget {
  const CreatePostHome({
    this.title,
    this.body,
    this.id,
    Key? key,
  }) : super(key: key);

  final String? title;
  final String? body;
  final String? id;

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

  late String? repliedPostChildId;
  late String? repliedPostChildTitle;
  late String? repliedPostChildBody;

  FocusedField focusedField = FocusedField.none;

  void setNoFocus() => setState(() {
        focusedField = FocusedField.none;
      });

  void setFocus(FocusedField focus) => setState(() {
        focusedField = focus;
      });

  double getLimitPercent() {
    if (focusedField == FocusedField.title) {
      return titleController.text.length / kPostTitleMaxLength;
    } else if (focusedField == FocusedField.body) {
      return bodyController.text.length / kPostTextMaxLength;
    } else {
      // Case for when [focusedField] is [FocusedField.none]
      return 0;
    }
  }

  late String titleHint;
  late String bodyHint;

  @override
  void initState() {
    repliedPostChildId = widget.id;
    repliedPostChildBody = widget.body;
    repliedPostChildTitle = widget.title;
    HintText hintText = getHint();
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
    titleController.addListener(() => setState(() {}));
    bodyController.addListener(() => setState(() {}));
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
    return BlocListener<DraftsCubit, DraftsState>(
      listener: (context, state) {
        if (state is LoadedFromDraft) {
          Navigator.pop(context);
          setState(() {
            titleController.text = state.title;
            bodyController.text = state.body;
            repliedPostChildId = state.repliedPostId;
            repliedPostChildBody = state.repliedPostBody;
            repliedPostChildTitle = state.repliedPostTitle;
          });
          showNotificationChip(context, "Draft loaded", notificationType: NotificationType.success);
        }
      },
      child: KeyboardDismiss(
        child: WillPopScope(
          onWillPop: () async => false,
          child: BlocListener<CreatePostCubit, CreatePostState>(
            listener: (context, state) async {
              if (state is SuccessfullySubmitted) {
                clearTextfields();
                Navigator.popUntil(context, ModalRoute.withName('/home'));
                CenterOverlay().show(context, "Posted", blastConfetti: true);
              }
            },
            child: ThemedStatusBar(
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
                              ? TextLimitTracker(
                                  value: getLimitPercent(),
                                )
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
                          Navigator.of(context).pushNamed('/home/create_post/details', arguments: {
                            'title': titleController.text,
                            'body': bodyController.text,
                            'id': repliedPostChildId, // TODO: add the id later (can be null?)
                          });
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
                                        print('save draft');
                                        context
                                            .read<DraftsCubit>()
                                            .saveDraft(
                                                context.read<UserCubit>().userId(),
                                                titleController.text,
                                                bodyController.text,
                                                repliedPostChildId,
                                                repliedPostChildTitle,
                                                repliedPostChildBody)
                                            .then((success) {
                                          if (success) {
                                            clearTextfields();
                                            Navigator.popUntil(context, ModalRoute.withName('/home'));
                                            showNotificationChip(context, "Draft saved",
                                                notificationType: NotificationType.success);
                                          } else {
                                            showNotificationChip(context, "Error saving draft");
                                          }
                                        });
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
                                                      onChanged: (value) => setState(() {}),
                                                      controller: titleController,
                                                      focusNode: titleFocusNode,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: null,
                                                      style: kDisplay1.copyWith(
                                                          color: Theme.of(context).colorScheme.primary),
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
                                                        onChanged: (value) => setState(() {}),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(kPostTextMaxLength),
                                                        ],
                                                        controller: bodyController,
                                                        focusNode: bodyFocusNode,
                                                        textCapitalization: TextCapitalization.sentences,
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        style: kBody.copyWith(
                                                            color: Theme.of(context).colorScheme.primary),
                                                        decoration: InputDecoration(
                                                          isCollapsed: true,
                                                          border: InputBorder.none,
                                                          hintMaxLines: 3,
                                                          hintText: bodyHint,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  repliedPostChildTitle != null && repliedPostChildBody != null
                                                      ? Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            InitScale(
                                                              child: ChildPost(
                                                                body: repliedPostChildBody as String,
                                                                title: repliedPostChildTitle as String,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
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
                                          child: TouchableOpacity(
                                            onTap: () => showDraftsSheet(context),
                                            child: Container(
                                              // width: double.infinity,
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
        ),
      ),
    );
  }
}
