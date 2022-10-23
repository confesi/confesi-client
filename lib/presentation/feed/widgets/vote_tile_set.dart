import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/feed/widgets/vote_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/utils/numbers/is_plural.dart';

class VoteTileSet extends StatelessWidget {
  const VoteTileSet({
    required this.likes,
    required this.hates,
    this.animateTiles = false,
    required this.postView,
    required this.comments,
    Key? key,
  }) : super(key: key);

  final bool animateTiles;
  final int likes;
  final int hates;
  final PostView postView;
  final int comments;

  Widget buildBody(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: VoteTile(
              value: hates,
              tooltipLocation: TooltipLocation.above,
              tooltip: 'hate this content',
              icon: CupertinoIcons.hand_thumbsdown,
              isActive: true,
              onTap: () => print('like'),
            ),
          ),
          const SizedBox(width: 10),
          postView == PostView.feedView
              ? Expanded(
                  child: Text(
                    isPlural(comments) == true ? "$comments comments" : "$comments comment",
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Container(),
          const SizedBox(width: 10),
          Expanded(
            child: VoteTile(
              value: likes,
              tooltipLocation: TooltipLocation.above,
              tooltip: 'like this content',
              icon: CupertinoIcons.hand_thumbsup,
              isActive: false,
              onTap: () => print('like'),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return animateTiles ? InitTransform(child: buildBody(context)) : buildBody(context);
  }
}
