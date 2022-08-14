import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteTileSet extends StatelessWidget {
  const VoteTileSet({
    required this.likes,
    required this.hates,
    Key? key,
  }) : super(key: key);

  final int likes;
  final int hates;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoteTile(
          value: likes,
          tooltipLocation: TooltipLocation.above,
          tooltip: 'like this content',
          icon: CupertinoIcons.hand_thumbsup,
          isActive: true,
          onTap: () => print('like'),
        ),
        const SizedBox(width: 10),
        VoteTile(
          value: hates,
          tooltipLocation: TooltipLocation.above,
          tooltip: 'hate this content',
          icon: CupertinoIcons.hand_thumbsdown,
          isActive: true,
          onTap: () => print('like'),
        ),
      ],
    );
  }
}
