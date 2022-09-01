import 'package:Confessi/domain/shared/entities/post.dart';
import 'package:Confessi/presentation/authentication/screens/home.dart';
import 'package:Confessi/presentation/create_post/cubit/post_cubit.dart';
import 'package:Confessi/presentation/create_post/utils/hint_text_generator.dart';
import 'package:Confessi/presentation/create_post/widgets/floating_button.dart';
import 'package:Confessi/presentation/create_post/widgets/text_limit_tracker.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/preview_quote_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/create_post/constants.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/layout/scrollable_view.dart';
import '../../shared/overlays/center_overlay_message.dart';
import '../../shared/overlays/snackbar.dart';

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
    Key? key,
  }) : super(key: key);

  final ViewMethod viewMethod;
  final String? title;
  final String? body;

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
    titleHint = '(optional) ${hintText.title}';
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

  void clearTextfields() {
    titleController.clear();
    bodyController.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
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

  bool get hasContent =>
      (titleController.text.isNotEmpty || bodyController.text.isNotEmpty);

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
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => titleFocusNode.requestFocus(),
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedSize(
                            duration: const Duration(milliseconds: 100),
                            child:
                                widget.viewMethod == ViewMethod.separateScreen
                                    ? buildButton()
                                    : hasContent
                                        ? buildButton()
                                        : Container(),
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: focusedField != FocusedField.none
                                  ? TextLimitTracker(
                                      value: getLimitPercent(),
                                    )
                                  : const TextLimitTracker(
                                      value: 0,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FloatingButton(
                            text: 'Add details',
                            onTap: () => Navigator.of(context).pushNamed(
                              '/home/create_post/details',
                              arguments: {
                                'title': titleController.text,
                                'body': bodyController.text,
                                'id': 'TEMP_ID', // TODO: add an actual id
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.shadow,
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
                                          mainAxisSize: MainAxisSize.max,
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
                                                      PreviewQuoteTile(
                                                        body: widget.body
                                                            as String,
                                                        title: widget.title
                                                            as String,
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
    );
  }
}
