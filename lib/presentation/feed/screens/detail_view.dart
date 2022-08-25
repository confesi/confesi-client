import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/layout/appbar.dart';
import 'package:Confessi/domain/feed/entities/post_child.dart';
import 'package:Confessi/presentation/feed/widgets/circle_comment_switcher_button.dart';
import 'package:Confessi/presentation/feed/widgets/comment_divider.dart';
import 'package:Confessi/presentation/feed/widgets/comment_sheet.dart';
import 'package:Confessi/presentation/feed/widgets/comment_tile.dart';
import 'package:Confessi/presentation/feed/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../../../constants/feed/constants.dart';
import '../../../constants/shared/feed.dart';
import '../../../domain/feed/entities/badge.dart';
import '../widgets/infinite_list.dart';

class Comment {
  final String data;
  final bool isRoot;

  Comment({required this.data, required this.isRoot});
}

class DetailViewScreen extends StatefulWidget {
  const DetailViewScreen({
    Key? key,
    required this.icon,
    required this.genre,
    required this.time,
    required this.faculty,
    required this.text,
    required this.title,
    required this.likes,
    required this.hates,
    required this.comments,
    required this.year,
    required this.university,
    required this.postChild,
    required this.badges,
  }) : super(key: key);

  final IconData icon;
  final String genre;
  final String time;
  final String faculty;
  final String text;
  final String title;
  final int likes;
  final int hates;
  final int year;
  final String university;
  final int comments;
  final PostChild postChild;
  final List<Badge> badges;

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  // Is the scrollview at the very top?
  bool atTop = true;

  // Should the button to jump between root comments be visible?
  bool visible = true;

  late InfiniteController controller;

  Future<void> onLoad() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() {
      controller.addItems([1, 2, 3]);
    });
  }

  Future<void> onRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      controller.setItems([1, 2, 3, 4]);
    });
  }

  @override
  void initState() {
    controller = InfiniteController(
      atTop: (isAtTop) {
        if (!mounted) return;
        setState(() {
          atTop = isAtTop;
        });
      },
      feedState: InfiniteListState.feedLoading,
      preloadBy: 25,
      items: [],
      rootIndexes: [10, 20, 30, 40],
      onLoad: () async => onLoad(),
      onRefresh: () async => onRefresh(),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This bottom sheet is overlayed atop transformed widgets (covers scrollview)
      // content during scrolling-to-fresh since that utilizes transforms.
      bottomSheet: Container(
        height: MediaQuery.of(context).padding.bottom,
        color: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            maintainBottomViewPadding: true,
            child: FooterLayout(
              footer: KeyboardAttachable(
                child: CommentSheet(
                  onSubmit: (comment) => print(comment),
                  maxCharacters: kMaxCommentLength,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppbarLayout(
                    centerWidget: Text(
                      'Thread View',
                      style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    leftIconVisible: true,
                    rightIcon: atTop ? null : CupertinoIcons.arrow_up_to_line,
                    rightIconVisible: atTop ? false : true,
                    rightIconOnPress: () {
                      atTop ? null : controller.scrollToTop();
                    },
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        InfiniteList(
                          controller: controller,
                          refreshIndicatorBackgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          // TODO: implement these widgets:
                          fullPageLoading: const Text('full page loading'),
                          fullPageError: const Text('full page error'),
                          fullPageEmpty: const Text('full page empty'),
                          feedLoading: const Text('feed loading'),
                          feedError: const Text('feed error'),
                          feedEmpty: const Text('feed empty'),
                          itemBuilder: (context, index) {
                            return CommentTile(
                              likes: index,
                              hates: index,
                              text: 'dummy text here: $index',
                              depth: CommentDepth.root,
                            );
                          },
                          header: Column(
                            children: [
                              PostTile(
                                badges: widget.badges,
                                postChild: widget.postChild,
                                icon: widget.icon,
                                postView: PostView.detailView,
                                university: widget.university,
                                genre: widget.genre,
                                time: widget.time,
                                faculty: widget.faculty,
                                text: widget.text,
                                title: widget.title,
                                likes: widget.likes,
                                hates: widget.hates,
                                comments: widget.comments,
                                year: widget.year,
                              ),
                              CommentDivider(
                                comments: widget.comments,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: KeyboardVisibilityBuilder(
                            builder: (context, isKeyboardVisible) {
                              return CircleCommentSwitcherButton(
                                visible: !isKeyboardVisible,
                                scrollToRootDirection:
                                    ScrollToRootDirection.down,
                                controller: controller,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child:
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
