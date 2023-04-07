import 'package:Confessi/constants/feed/enums.dart';
import 'package:Confessi/presentation/feed/widgets/comment_tile.dart';
import 'package:Confessi/presentation/feed/widgets/simple_comment_root_group.dart';
import 'package:Confessi/presentation/feed/widgets/simple_comment_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:scrollable/exports.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../shared/buttons/option.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/button_options_sheet.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';
import '../widgets/comment_sheet.dart';
import '../widgets/simple_comment_sort.dart';

class SimpleDetailViewScreen extends StatefulWidget {
  const SimpleDetailViewScreen({super.key});

  @override
  State<SimpleDetailViewScreen> createState() => _SimpleDetailViewScreenState();
}

class _SimpleDetailViewScreenState extends State<SimpleDetailViewScreen> {
  late CommentSheetController commentSheetController;

  @override
  void initState() {
    commentSheetController = CommentSheetController();
    super.initState();
  }

  // Show the options for this post.
  void buildOptionsSheet(BuildContext context) => showButtonOptionsSheet(context, [
        OptionButton(
          text: "Quote",
          icon: CupertinoIcons.paperplane,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Save",
          icon: CupertinoIcons.bookmark,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Details",
          icon: CupertinoIcons.info,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Report",
          icon: CupertinoIcons.flag,
          onTap: () => print("tap"),
        ),
      ]);

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
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.8,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
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
                        maxCharacters: 10,
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
                    icon3OnPress: () => commentSheetController.unfocus(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    Text(
                                      "I found out all the stats profs are in a conspiracy ring together!",
                                      style: kTitle.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 24 * context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
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
                                        fontSize: kDetail.fontSize! *
                                            context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan.",
                                      style: kBody.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: kBody.fontSize! *
                                            context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 15),
                                    // const CommentSortTile(),
                                    // SimpleTextButton(
                                    //   infiniteWidth: true,
                                    //   onTap: () => print("tap"),
                                    //   text: "Sort by: most liked",
                                    // ),
                                    SimpleCommentSort(
                                      onSwitch: (sortMode) => print(sortMode),
                                    ),
                                    // const CommentTile(
                                    //   likes: 3,
                                    //   hates: 3,
                                    //   text: "text",
                                    //   depth: CommentDepth.one,
                                    // ),
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

                                    // const SimpleCommentTile(depth: CommentDepth.one),
                                    // const SimpleCommentTile(depth: CommentDepth.two),
                                    // const SimpleCommentTile(depth: CommentDepth.three),
                                    // const SimpleCommentTile(depth: CommentDepth.three),
                                    // const SimpleCommentTile(depth: CommentDepth.four),
                                    // const SimpleCommentTile(depth: CommentDepth.three),

                                    // const SimpleCommentTile(depth: CommentDepth.root),
                                    // const SimpleCommentTile(depth: CommentDepth.one),
                                    // const SimpleCommentTile(depth: CommentDepth.two),
                                    // const SimpleCommentTile(depth: CommentDepth.three),
                                    // const SimpleCommentTile(depth: CommentDepth.four),
                                    // const SimpleCommentTile(depth: CommentDepth.four),
                                    // const SimpleCommentTile(depth: CommentDepth.four),
                                    // const SimpleCommentTile(depth: CommentDepth.root),
                                    // const SimpleCommentTile(depth: CommentDepth.one),
                                    // const SimpleCommentTile(depth: CommentDepth.two),
                                    // const SimpleCommentTile(depth: CommentDepth.three),
                                    // const SimpleCommentTile(depth: CommentDepth.two),
                                    // const SimpleCommentTile(depth: CommentDepth.three),
                                    // const SimpleCommentTile(depth: CommentDepth.root),
                                    // const SimpleCommentTile(depth: CommentDepth.root),
                                    // const SimpleCommentTile(depth: CommentDepth.root),
                                    // const SimpleCommentTile(depth: CommentDepth.one),
                                    // const SimpleCommentTile(depth: CommentDepth.root),

                                    const SizedBox(height: 15),
                                  ],
                                ),
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
