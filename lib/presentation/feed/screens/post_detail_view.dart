import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/application/user/cubit/saved_posts_cubit.dart';
import 'package:confesi/core/utils/numbers/add_commas_to_number.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:scrollable/exports.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../comments/widgets/comment_text_sheet.dart';
import '../methods/show_post_options.dart';
import '../utils/post_metadata_formatters.dart';
import '../../shared/behaviours/one_theme_status_bar.dart';
import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';
import '../../comments/widgets/comments_section.dart';

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
    // post frame callback
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.props.openKeyboard) commentSheetController.focus();
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
    Post post = Provider.of<GlobalContentService>(context).posts[widget.props.post.id]!;
    return OneThemeStatusBar(
      brightness: Brightness.light,
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: FooterLayout(
            // footer: Container(
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).colorScheme.background,
            //     border: Border(
            //       top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Theme.of(context).colorScheme.shadow.withOpacity(0.8),
            //         blurRadius: 20,
            //         spreadRadius: 15,
            //       ),
            //     ],
            //   ),
            //   child: AnimatedSwitcher(
            //     duration: const Duration(milliseconds: 250),
            //     child: context.watch<CommentSectionCubit>().state is! CommentSectionData
            //         ? const SizedBox()
            //         : Align(
            //             alignment: Alignment.bottomCenter,
            //             child: SafeArea(
            //               top: true,
            //               child: KeyboardAttachable(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(10),
            //                   child: CommentSheet(
            //                     controller: commentSheetController,
            //                     onSubmit: (comment) => print(comment),
            //                     maxCharacters: kMaxCommentLength,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //   ),
            // ),
            child: Column(
              children: [
                StatTileGroup(
                  icon1Text: "Back",
                  icon2Text: addCommasToNumber(221), // todo: comment count
                  icon4Text: addCommasToNumber(post.upvote),
                  icon5Text: addCommasToNumber(post.downvote),
                  icon1OnPress: () => router.pop(context),
                  icon2OnPress: () => commentSheetController.focus(),
                  icon4OnPress: () async => await Provider.of<GlobalContentService>(context, listen: false)
                      .voteOnPost(post, post.userVote != 1 ? 1 : 0)
                      .then((value) => value.fold((err) => context.read<NotificationsCubit>().show(err), (_) => null)),
                  icon5OnPress: () async => await Provider.of<GlobalContentService>(context, listen: false)
                      .voteOnPost(post, post.userVote != -1 ? -1 : 0)
                      .then((value) => value.fold((err) => context.read<NotificationsCubit>().show(err), (_) => null)),
                  icon4Selected: post.userVote == 1,
                  icon5Selected: post.userVote == -1,
                ),
                Expanded(
                  child: SwipeRefresh(
                    onRefresh: () async {
                      await context.read<SavedPostsCubit>().loadPosts(refresh: true, fullScreenRefresh: true).then(
                            (_) async => await context
                                .read<CommentSectionCubit>()
                                .loadInitial(widget.props.post.id, CommentSortType.recent, refresh: true, fullScreenRefresh: true),
                          );
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text(
                              post.title,
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
                                  "${post.school.name}${buildFaculty(post)}${buildYear(post)} • ${post.category.category.capitalize()}",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${timeAgoFromMicroSecondUnixTime(post)} • ${post.emojis.map((e) => e).join(" ")}",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              post.content,
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 15),
                            CommentSheetView(post: post),
                          ],
                        ),
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
