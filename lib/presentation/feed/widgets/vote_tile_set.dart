import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/large_number_formatter.dart';
import 'package:Confessi/presentation/feed/widgets/vote_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteTileSet extends StatelessWidget {
  const VoteTileSet({
    required this.likes,
    required this.hates,
    this.animateTiles = false,
    Key? key,
  }) : super(key: key);

  final bool animateTiles;
  final int likes;
  final int hates;

  Widget buildBody() => Row(
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
          const SizedBox(width: 15),
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
    return animateTiles ? InitTransform(child: buildBody()) : buildBody();
  }
}
