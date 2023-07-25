import '../../../constants/feed/enums.dart';
import '../methods/show_post_options.dart';
import '../widgets/simple_comment_root_group.dart';
import '../../shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:scrollable/exports.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

import '../../../application/shared/cubit/maps_cubit.dart';
import '../../../constants/feed/general.dart';
import '../../../core/services/sharing.dart';
import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';
import '../widgets/comment_sheet.dart';
import '../widgets/simple_comment_sort.dart';
import '../widgets/simple_comment_tile.dart';

class SimpleDetailViewScreen extends StatefulWidget {
  const SimpleDetailViewScreen({super.key});

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
          "Want to share this instead?",
          notificationType: NotificationType.success,
          onTap: () => Sharing().sharePost(context, "link", "title", "body", "university", "timeAgo"),
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
    return BlocListener<MapsCubit, MapsLauncherState>(
      listener: (context, state) {
        if (state is MapsLauncherError) {
          showNotificationChip(context, state.message);
          // set to base
          context.read<MapsCubit>().setContactStateToBase();
        }
      },
      child: OneThemeStatusBar(
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
                      icon1OnPress: () => Navigator.pop(context),
                      icon2OnPress: () => commentSheetController.focus(),
                      icon3OnPress: () => Sharing().sharePost(context, "link", "title", "body", "university",
                          "timeAgo"), // commentSheetController.unfocus()
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
                                            "I found out all the stats profs are in a conspiracy ring together!",
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
                                                onTap: () => buildOptionsSheet(context),
                                                text: "Advanced options",
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            "Year 1 Computer Science / Politics / 22min ago / University of Victoria",
                                            style: kDetail.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan.",
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
          )),
    );
  }
}
