import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/behaviours/overscroll.dart';
import 'package:Confessi/core/widgets/layout/appbar.dart';
import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../../constants.dart';

class DetailViewScreen extends StatefulWidget {
  const DetailViewScreen({
    Key? key,
    required this.genre,
    required this.time,
    required this.faculty,
    required this.text,
    required this.votes,
    required this.comments,
    required this.year,
    required this.university,
  }) : super(key: key);

  final String genre;
  final String time;
  final String faculty;
  final String text;
  final int votes;
  final int year;
  final String university;
  final String comments;

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  double scrollableOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
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
              ),
              Expanded(
                child: CupertinoScrollbar(
                  child: ScrollConfiguration(
                    behavior: NoOverScrollSplash(),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          PostTile(
                            postView: PostView.detailView,
                            university: widget.university,
                            genre: widget.genre,
                            time: widget.time,
                            faculty: widget.faculty,
                            text: widget.text,
                            votes: widget.votes,
                            comments: widget.comments,
                            year: widget.year,
                          ),
                          LineLayout(
                              horizontalPadding: 15,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          const CommentTile(),
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
    );
  }
}
