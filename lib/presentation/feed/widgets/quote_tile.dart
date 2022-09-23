import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/tool_tip.dart';
import 'package:Confessi/constants/feed/general.dart';
import 'package:Confessi/domain/shared/entities/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/styles/typography.dart';

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
              'badges': post.badges,
              'post_child': post.child,
              'icon': post.icon,
              'genre': post.genre,
              'time': post.createdDate,
              'faculty': post.faculty,
              'text': post.text,
              'title': post.title,
              'likes': post.likes,
              'hates': post.hates,
              'comments': post.comments,
              'year': post.year,
              'university': post.university,
              'postView': PostView.detailView,
              'university_full_name': post.universityFullName,
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
                  post.title.isNotEmpty
                      ? Text(
                          post.title.length > kPreviewQuotePostTitleLength &&
                                  postView == PostView.feedView
                              ? "${post.title.substring(0, kPreviewQuotePostTitleLength)}..."
                              : post.title,
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.left,
                        )
                      : Container(),
                  post.title.isNotEmpty
                      ? const SizedBox(height: 5)
                      : Container(),
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
