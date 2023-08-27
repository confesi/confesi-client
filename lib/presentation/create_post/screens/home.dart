import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/create_post/widgets/img.dart';
import 'package:confesi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';

import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/creating_and_editing_posts_service/create_edit_posts_service.dart';
import '../../../init.dart';

import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/overlays/notification_chip.dart';
import 'package:scrollable/exports.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/other/text_limit_tracker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/create_post_hint_text/create_post_hint_text.dart';
import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/layout/scrollable_area.dart';
import '../overlays/confetti_blaster.dart';

enum FocusedField { title, body, none }

class CreatePostHome extends StatefulWidget {
  const CreatePostHome({
    Key? key,
    required this.props,
  }) : super(key: key);

  final GenericPost props;

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
  final ImgController imgController = ImgController();

  FocusedField focusedField = FocusedField.none;

  void setNoFocus() => setState(() => focusedField = FocusedField.none);

  void setFocus(FocusedField focus) => setState(() => focusedField = focus);

  double getLimitPercent() {
    if (focusedField == FocusedField.title) {
      return titleController.text.runes.length / kPostTitleMaxLength;
    } else if (focusedField == FocusedField.body) {
      return bodyController.text.runes.length / kPostBodyMaxLength;
    } else {
      // Case for when [focusedField] is [FocusedField.none]
      return 0;
    }
  }

  late String titleHint;
  late String bodyHint;
  // preload for the drafts sheet

  @override
  void initState() {
    // hint text
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
    // edited post
    if (widget.props is EditedPost) {
      titleController.text = (widget.props as EditedPost).title;
      bodyController.text = (widget.props as EditedPost).body;
      hintText.body = "...";
      hintText.title = "...";
    }
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

  void clearTextfields() {
    titleController.clear();
    bodyController.clear();
    FocusScope.of(context).unfocus();
  }

  void updateTextWithCursor({
    required String Function(String) updateCallback,
    required TextEditingController controller,
    required TextSelection newCursorPosition,
  }) {
    final updatedText = updateCallback(controller.text);

    controller.text = updatedText;

    if (newCursorPosition.extentOffset <= updatedText.length) {
      controller.selection = newCursorPosition;
    } else {
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: updatedText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardDismiss(
      child: NavBlocker(
        blocking: Provider.of<CreatingEditingPostsService>(context).metaState is CreatingEditingPostMetaStateLoading,
        child: ThemeStatusBar(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              body: FooterLayout(
                footer: SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: widget.props is EditedPost
                        ? Text(
                            "You can't edit a confession's images, sorry!",
                            style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                            textAlign: TextAlign.center,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleIconBtn(
                                color: Theme.of(context).colorScheme.secondary,
                                icon: CupertinoIcons.photo,
                                onTap: () async {
                                  await imgController.selectFromGallery();
                                },
                              ),
                              CircleIconBtn(
                                color: Theme.of(context).colorScheme.secondary,
                                icon: CupertinoIcons.camera,
                                onTap: () async {
                                  await imgController.selectFromCamera();
                                },
                              )
                            ],
                          ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      AppbarLayout(
                        bottomBorder: true,
                        centerWidget: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: focusedField != FocusedField.none
                              ? SizedBox(
                                  width: widthFraction(context, 1),
                                  child: Center(child: TextLimitTracker(value: getLimitPercent())))
                              : Text(
                                  widget.props is EditedPost ? "Edit confession" : "Create confession",
                                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        rightIconVisible: true,
                        rightIcon: widget.props is EditedPost ? CupertinoIcons.check_mark : CupertinoIcons.arrow_right,
                        rightIconLoading: Provider.of<CreatingEditingPostsService>(context).metaState
                            is CreatingEditingPostMetaStateLoading,
                        rightIconOnPress: () async {
                          final provider = Provider.of<CreatingEditingPostsService>(context, listen: false);
                          provider.title = titleController.text;
                          provider.body = bodyController.text;
                          if (widget.props is EditedPost) {
                            (await provider.editPost(provider.title, provider.body, (widget.props as EditedPost).id))
                                .fold(
                              (_) {
                                sl.get<ConfettiBlaster>().show(context);
                                provider.clear();
                                router.pop();
                              },
                              (failureMsg) => context.read<NotificationsCubit>().showErr(failureMsg),
                            );
                            return;
                          } else if (titleController.text.trim().isEmpty && bodyController.text.trim().isEmpty) {
                            showNotificationChip(context, "You can't post... nothing!");
                            return;
                          }

                          FocusManager.instance.primaryFocus?.unfocus();
                          router
                              .push(
                                "/create/details",
                                extra: CreatePostDetailsProps(
                                  widget.props is EditedPost
                                      ? EditedPost(
                                          titleController.text, bodyController.text, (widget.props as EditedPost).id)
                                      : CreatingNewPost(
                                          title: titleController.text,
                                          body: bodyController.text,
                                        ),
                                ),
                              )
                              .then((value) => FocusScope.of(context).unfocus());
                        },
                        leftIconVisible: true,
                        leftIcon: CupertinoIcons.xmark,
                        leftIconOnPress: () {
                          Provider.of<CreatingEditingPostsService>(context, listen: false).clear();
                          router.pop(context);
                        },
                        backgroundColor: Theme.of(context).colorScheme.background,
                      ),
                      Expanded(
                        child: Container(
                          color: Theme.of(context).colorScheme.shadow,
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
                                            thumbVisible: false,
                                            physics: const BouncingScrollPhysics(),
                                            controller: scrollController,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Img(controller: imgController, maxImages: maxImagesPerPost),
                                                Container(
                                                  height: 15,
                                                  color: Colors.transparent,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  // Transparent hitbox trick.
                                                  color: Colors.transparent,
                                                  child: TextField(
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(kPostTitleMaxLength),
                                                    ],
                                                    onChanged: (value) {
                                                      updateTextWithCursor(
                                                        updateCallback: (v) =>
                                                            context.read<PostCategoriesCubit>().updateTitle(v),
                                                        controller: titleController,
                                                        newCursorPosition: titleController.selection,
                                                      );
                                                      setState(() {});
                                                    },
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
                                                      hintMaxLines: 1,
                                                      hintText: titleHint,
                                                      hintStyle: kDisplay1.copyWith(
                                                        color: Theme.of(context).colorScheme.onSurface,
                                                      ),
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
                                                    child: const SizedBox(height: 5),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => bodyFocusNode.requestFocus(),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                                    // Transparent hitbox trick.
                                                    color: Colors.transparent,
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        updateTextWithCursor(
                                                          updateCallback: (v) =>
                                                              context.read<PostCategoriesCubit>().updateBody(v),
                                                          controller: bodyController,
                                                          newCursorPosition: bodyController.selection,
                                                        );
                                                        setState(() {});
                                                      },
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(kPostTitleMaxLength),
                                                      ],
                                                      controller: bodyController,
                                                      focusNode: bodyFocusNode,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: null,
                                                      style:
                                                          kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                                                      decoration: InputDecoration(
                                                        isCollapsed: true,
                                                        border: InputBorder.none,
                                                        hintMaxLines: 3,
                                                        hintText: bodyHint,
                                                        hintStyle: kBody.copyWith(
                                                            color: Theme.of(context).colorScheme.onSurface),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: bottomSafeArea(context) + heightFraction(context, 1 / 4),
                                                ), // Adds some padding to the bottom.
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
