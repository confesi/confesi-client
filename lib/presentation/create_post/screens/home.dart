import 'package:Confessi/application/create_post/post_cubit.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/other/text_limit_tracker.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/preview_quote_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_burst.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/buttons/option.dart';
import 'package:Confessi/presentation/shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/create_post/general.dart';
import '../../../core/generators/hint_text_generator.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/layout/scrollable_view.dart';
import '../../shared/overlays/center_overlay_message.dart';

// TODO: move to feature constants file and document
enum FocusedField {
  title,
  body,
  none,
}

// TODO: move to constants??
enum ViewMethod {
  separateScreen,
  tabScreen,
}

class CreatePostHome extends StatefulWidget {
  const CreatePostHome({
    required this.viewMethod,
    this.title,
    this.body,
    this.id,
    Key? key,
  }) : super(key: key);

  final ViewMethod viewMethod;
  final String? title;
  final String? body;
  final String? id;

  @override
  State<CreatePostHome> createState() => _CreatePostHomeState();
}

class _CreatePostHomeState extends State<CreatePostHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController scrollController = ScrollController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode bodyFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

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
    HintText hintText = getHint();
    titleHint = '${hintText.title} (optional)';
    bodyHint = hintText.body;
    titleFocusNode.addListener(() {
      context.read<CreatePostCubit>().setUserEnteringData();
      setNoFocus();
      if (titleFocusNode.hasFocus) setFocus(FocusedField.title);
    });
    bodyFocusNode.addListener(() {
      context.read<CreatePostCubit>().setUserEnteringData();
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

  bool isEmpty() => titleController.text.isEmpty && bodyController.text.isEmpty;

  void clearTextfields() {
    titleController.clear();
    bodyController.clear();
    FocusScope.of(context).unfocus();
  }

  Widget buildButton() => Row(
        children: [
          TouchableOpacity(
            onTap: () {
              if (widget.viewMethod == ViewMethod.separateScreen) {
                Navigator.pop(context);
              } else {
                clearTextfields();
              }
            },
            child: Container(
              // Transparen hitbox trick.
              color: Colors.transparent,
              child: const Icon(
                CupertinoIcons.xmark,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<CreatePostCubit, CreatePostState>(
        listener: (context, state) async {
          if (state is SuccessfullySubmitted) {
            clearTextfields();
            Navigator.popUntil(context, ModalRoute.withName('/home'));
            CenterOverlay().show(context);
            setState(() {});
          }
        },
        child: ThemedStatusBar(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: ShrinkingView(
              // safeAreaBottom: true,
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
                              style: kTitle.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                    ),
                    rightIconVisible: true,
                    rightIcon: CupertinoIcons.arrow_right,
                    rightIconOnPress: () {
                      context.read<CreatePostCubit>().setUserEnteringData();
                      Navigator.of(context)
                          .pushNamed('/home/create_post/details', arguments: {
                        'title': titleController.text,
                        'body': bodyController.text,
                        'id': widget.id, // TODO: add the id later (can be null?)
                      });
                      FocusScope.of(context).unfocus();
                    },
                    leftIconDisabled:
                        isEmpty() && widget.viewMethod == ViewMethod.tabScreen
                            ? true
                            : false,
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
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/home'));
                                    setState(() {});
                                  },
                                  text: "Discard",
                                  icon: CupertinoIcons.trash,
                                ),
                                OptionButton(
                                  onTap: () {
                                    print('save draft');
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
                                return KeyboardDismissLayout(
                                  child: GestureDetector(
                                    onTap: () => bodyFocusNode.requestFocus(),
                                    child: SizedBox(
                                      height: constraints.maxHeight,
                                      child: ScrollableView(
                                        physics: const ClampingScrollPhysics(),
                                        controller: scrollController,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                    LengthLimitingTextInputFormatter(
                                                        kPostTitleMaxLength),
                                                  ],
                                                  onChanged: (value) =>
                                                      setState(() {}),
                                                  controller: titleController,
                                                  focusNode: titleFocusNode,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  style: kHeader.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
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
                                                onTap: () =>
                                                    titleFocusNode.requestFocus(),
                                                child: Container(
                                                  // Transparent hitbox trick.
                                                  color: Colors.transparent,
                                                  width: double.infinity,
                                                  child:
                                                      const SizedBox(height: 15),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    bodyFocusNode.requestFocus(),
                                                child: Container(
                                                  // Transparent hitbox trick.
                                                  color: Colors.transparent,
                                                  child: TextField(
                                                    onChanged: (value) =>
                                                        setState(() {}),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          kPostTextMaxLength),
                                                    ],
                                                    controller: bodyController,
                                                    focusNode: bodyFocusNode,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    style: kBody.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                    decoration: InputDecoration(
                                                      isCollapsed: true,
                                                      border: InputBorder.none,
                                                      hintMaxLines: 3,
                                                      hintText: bodyHint,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              widget.title != null &&
                                                      widget.body != null
                                                  ? Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        InitScale(
                                                          child: PreviewQuoteTile(
                                                            body: widget.body
                                                                as String,
                                                            title: widget.title
                                                                as String,
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
