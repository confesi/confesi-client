import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/core/utils/numbers/add_commas_to_number.dart';
import 'package:confesi/models/post.dart';

import '../../../constants/feed/enums.dart';
import '../../../core/router/go_router.dart';
import '../methods/show_post_options.dart';
import '../utils/post_metadata_formatters.dart';
import '../widgets/simple_comment_root_group.dart';
import '../../shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:scrollable/exports.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

import '../../../constants/feed/general.dart';
import '../../../core/services/sharing/sharing.dart';
import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';
import '../widgets/comment_sheet.dart';
import '../widgets/simple_comment_sort.dart';
import '../widgets/simple_comment_tile.dart';

class SimpleDetailViewScreen extends StatefulWidget {
  const SimpleDetailViewScreen({super.key, required this.props});

  final HomePostsDetailProps props;

  @override
  State<SimpleDetailViewScreen> createState() => _SimpleDetailViewScreenState();
}

class _SimpleDetailViewScreenState extends State<SimpleDetailViewScreen> {
  late CommentSheetController commentSheetController;
  late ScreenshotCallback screenshotCallback;
  @override
  void initState() {
    commentSheetController = CommentSheetController();
    screenshotCallback = ScreenshotCallback();
    screenshotCallback.addListener(
      () {
        showNotificationChip(
          context,
          "Tap here to share this instead",
          notificationType: NotificationType.success,
          onTap: () => context.read<QuickActionsCubit>().sharePost(context, widget.props.post),
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OneThemeStatusBar(
        brightness: Brightness.light,
        child: KeyboardDismiss(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: FooterLayout(
              footer: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 15,
                      ),
                    ]),
                child: SafeArea(
                  top: false,
                  child: KeyboardAttachable(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CommentSheet(
                        controller: commentSheetController,
                        onSubmit: (comment) => print(comment),
                        maxCharacters: kMaxCommentLength,
                      ),
                    ),
                  ),
                ),
              ),
              child: Column(
                children: [
                  StatTileGroup(
                    icon1Text: "Back",
                    icon2Text: addCommasToNumber(221), // todo: comment count
                    icon4Text: addCommasToNumber(widget.props.post.upvote),
                    icon5Text: addCommasToNumber(widget.props.post.downvote),
                    icon1OnPress: () => router.pop(context),
                    icon2OnPress: () => commentSheetController.focus(),

                    icon4OnPress: () => commentSheetController.delete(),
                    icon5OnPress: () => commentSheetController.setBlocking(!commentSheetController.isBlocking),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 15),
                                        Text(
                                          widget.props.post.title,
                                          style: kDisplay1.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 15),
                                        Wrap(
                                          runSpacing: 10,
                                          spacing: 10,
                                          children: [
                                            SimpleTextButton(
                                              onTap: () => buildOptionsSheet(context, widget.props.post),
                                              text: "Advanced options",
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${widget.props.post.school.name}${buildFaculty(widget.props.post)}${buildYear(widget.props.post)} • ${widget.props.post.category.category}",
                                              style: kDetail.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "${timeAgoFromMicroSecondUnixTime(widget.props.post)} • ${widget.props.post.emojis.map((e) => e).join(" ")}",
                                              style: kDetail.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          widget.props.post.content,
                                          style: kBody.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 15),
                                        SimpleCommentSort(
                                          onSwitch: (sortMode) => print(sortMode),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SimpleCommentRootGroup(
                                    root: SimpleCommentTile(depth: CommentDepth.root),
                                    subTree: [
                                      SimpleCommentRootGroup(
                                        root: SimpleCommentTile(depth: CommentDepth.one),
                                        subTree: [
                                          SimpleCommentRootGroup(
                                            root: SimpleCommentTile(depth: CommentDepth.two),
                                            subTree: [
                                              SimpleCommentRootGroup(
                                                root: SimpleCommentTile(depth: CommentDepth.three),
                                                subTree: [],
                                              ),
                                            ],
                                          ),
                                          SimpleCommentRootGroup(
                                            root: SimpleCommentTile(depth: CommentDepth.two),
                                            subTree: [],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SimpleCommentTile(depth: CommentDepth.one),
                                  const SimpleCommentTile(depth: CommentDepth.two),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(height: bottomSafeArea(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
