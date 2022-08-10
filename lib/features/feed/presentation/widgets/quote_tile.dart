import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/widgets/behaviours/tool_tip.dart';
import 'package:Confessi/features/feed/constants.dart';
import 'package:Confessi/features/feed/domain/entities/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class QuoteTile extends StatelessWidget {
  const QuoteTile({
    required this.postView,
    required this.post,
    Key? key,
  }) : super(key: key);

  final PostView postView;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return ToolTip(
      message: 'view quoted post',
      tooltipLocation: TooltipLocation.above,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pushNamed(
            context,
            '/home/detail',
            arguments: {
              'post_child': post.child,
              'icon': post.icon,
              'genre': post.genre,
              'time': post.createdDate,
              'faculty': post.faculty,
              'text': post.text,
              'votes': post.votes,
              'comments': post.commentCount,
              'year': post.year,
              'university': post.university,
              'postView': PostView.detailView
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Replying to:',
              style: kDetail.copyWith(
                  color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 0.7,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.genre,
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    post.text.length > kPreviewQuotePostTextLength &&
                            postView == PostView.feedView
                        ? "${post.text.substring(0, kPreviewQuotePostTextLength)}..."
                        : post.text,
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
