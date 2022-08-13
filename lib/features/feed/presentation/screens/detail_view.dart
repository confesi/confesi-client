import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/widgets/layout/appbar.dart';
import 'package:Confessi/core/widgets/layout/scrollable_view.dart';
import 'package:Confessi/features/feed/domain/entities/post_child.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_divider.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_tile.dart';
import 'package:Confessi/features/feed/presentation/widgets/post_tile.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../../constants.dart';

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
  double scrollableOffset = 0.0;
  bool isRefreshing = false;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
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
            mainAxisSize: MainAxisSize.min,
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
                child: CustomRefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      isRefreshing = true;
                    });
                    HapticFeedback.lightImpact();
                    await Future.delayed(const Duration(milliseconds: 400));
                    // await widget.onRefresh();
                    setState(() {
                      isRefreshing = false;
                    });
                    await Future.delayed(const Duration(milliseconds: 400));
                    // _fetchMore();
                  },
                  builder: (BuildContext context, Widget child,
                      IndicatorController controller) {
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, _) {
                        return Stack(
                          clipBehavior: Clip.hardEdge,
                          children: <Widget>[
                            AnimatedBuilder(
                              animation: controller,
                              builder: (BuildContext context, _) {
                                return Container(
                                  color: Theme.of(context).colorScheme.shadow,
                                  width: double.infinity,
                                  height: controller.value * 80,
                                  child: FittedBox(
                                    alignment: Alignment.center,
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: CupertinoActivityIndicator(
                                        radius: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Transform.translate(
                              offset: Offset(0, controller.value * 80),
                              child: child,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: isRefreshing,
                    child: ScrollableView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Column(
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
                          // TODO: make comments an int
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
                          const CommentTile(
                            depth: CommentDepth.root,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                          ),
                          const CommentTile(
                            depth: CommentDepth.one,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                          ),
                          const CommentTile(
                            depth: CommentDepth.two,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                          ),
                          const CommentTile(
                            depth: CommentDepth.two,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                          ),
                          const CommentTile(
                            depth: CommentDepth.three,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                          ),
                          const CommentTile(
                            depth: CommentDepth.four,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
                          ),
                          const CommentTile(
                            depth: CommentDepth.two,
                            likes: 1093841,
                            hates: 19023,
                            text:
                                'This is a dummy comment that acts as a base to show what a comment should look like. Now I\'m just writing random stuff.',
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
