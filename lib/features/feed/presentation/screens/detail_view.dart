import 'dart:math';

import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/layout/appbar.dart';
import 'package:Confessi/features/feed/domain/entities/post_child.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_divider.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/infinite_comment_thread.dart';
import 'package:Confessi/features/feed/presentation/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    for (var i = 0; i < 100; i++) {
      var result = Random().nextInt(3);
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

  bool isAtTop = true;

  Widget buildComment(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.lightBlueAccent,
      child: Text('Comment: ${comments[index - 1].isRoot}'),
    );
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
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: FooterLayout(
          footer: KeyboardAttachable(
            child: CommentSheet(
              onSubmit: (comment) => print(comment),
              maxCharacters: kMaxCommentLength,
            ),
          ),
          child: Column(
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
                rightIconVisible: true,
                rightIconOnPress: () {
                  FocusScope.of(context).unfocus();
                  isAtTop ? controller.refresh() : controller.scrollToTop();
                },
                rightIconTooltip: 'scroll to top',
                leftIconTooltip: 'go back',
              ),
              Expanded(
                child: InfiniteCommentThread(
                  comment: buildComment,
                  loadMore: () async => await loadMore(),
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
                      const CommentTile(
                        depth: CommentDepth.root,
                        likes: 1093841,
                        hates: 19023,
                        text:
                            'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                      ),
                    ],
                  ),
                  comments: comments,
                  controller: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
