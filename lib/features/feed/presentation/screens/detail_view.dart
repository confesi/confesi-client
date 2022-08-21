import 'dart:math';

import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/layout/appbar.dart';
import 'package:Confessi/features/feed/domain/entities/post_child.dart';
import 'package:Confessi/features/feed/presentation/widgets/circle_comment_switcher_button.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_divider.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/infinite_comment_thread.dart';
import 'package:Confessi/features/feed/presentation/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../../constants.dart';
import '../../domain/entities/badge.dart';

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
  List<Comment> comments = [];

  Future<void> loadMore() async {
    print('<=== load more ===>');
    print('.');
    for (var i = 0; i < 20; i++) {
      var result = Random().nextInt(8);
      comments
          .add(Comment(data: 'some data', isRoot: result == 1 ? true : false));
      if (result == 1 && !controller.rootIndexes.contains(comments.length)) {
        controller.addToRootIndexes(comments.length);
      }
    }
  }

  // Controller for the comment thread.
  InfiniteCommentThreadController<Comment> controller =
      InfiniteCommentThreadController<Comment>();

  // Is the scrollview at the very top?
  bool isAtTop = true;

  Widget buildComment(int index) {
    return CommentTile(
      likes: 12,
      hates: 490,
      text: '${comments[index - 1].data} : ${index - 1}',
      depth: comments[index - 1].isRoot ? CommentDepth.root : CommentDepth.one,
    );
  }

  // Should the button to jump between root comments be visible?
  bool visible = true;

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
                    rightIcon: isAtTop ? null : CupertinoIcons.arrow_up_to_line,
                    rightIconVisible: isAtTop ? false : true,
                    rightIconOnPress: () {
                      isAtTop ? null : controller.scrollToTop();
                    },
                    rightIconTooltip: 'scroll to top',
                    leftIconTooltip: 'go back',
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        InfiniteCommentThread(
                          preloadBy: 10,
                          comment: buildComment,
                          loadMore: () async {
                            print('PREFETCHING');
                            print(',.');
                            await loadMore();
                          },
                          refreshScreen: () async {
                            print('refresh');
                            controller.clearComments();
                            setState(() {
                              loadMore();
                            });
                          },
                          onTopChange: (atTop) {
                            if (atTop != isAtTop) {
                              setState(() {
                                isAtTop = atTop;
                              });
                            }
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
                          comments: comments,
                          controller: controller,
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
