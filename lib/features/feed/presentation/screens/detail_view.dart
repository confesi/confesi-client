import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/behaviours/overscroll.dart';
import 'package:Confessi/core/widgets/layout/keyboard_dismiss.dart';
import 'package:Confessi/core/widgets/layout/line.dart';
import 'package:Confessi/core/widgets/textfields/bulge.dart';
import 'package:Confessi/core/widgets/textfields/thin.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/layout/minimal_appbar.dart';
import '../../constants.dart';

class DetailViewScreen extends StatefulWidget {
  const DetailViewScreen({
    Key? key,
    required this.genre,
    required this.time,
    required this.faculty,
    required this.text,
    required this.likes,
    required this.hates,
    required this.comments,
    required this.year,
    required this.university,
  }) : super(key: key);

  final String genre;
  final String time;
  final String faculty;
  final String text;
  final int likes;
  final int hates;
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
    return KeyboardDismissLayout(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            bottomSheet: Container(
              color: Theme.of(context).colorScheme.background,
              child: CommentSheet(
                maxCharacters: kMaxCommentLength,
                onSubmit: (comment) => print(comment),
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Column(
              children: [
                const MinimalAppbarLayout(farLeft: true),
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
                              likes: widget.likes,
                              hates: widget.hates,
                              comments: widget.comments,
                              year: widget.year,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: LineLayout(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                            Container(
                              color: Colors.redAccent,
                              height: 300,
                            ),
                            Container(
                              color: Colors.blue,
                              height: MediaQuery.of(context).viewPadding.bottom,
                            ),
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
