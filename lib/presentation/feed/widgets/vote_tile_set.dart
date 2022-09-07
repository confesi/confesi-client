import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/large_number_formatter.dart';
import 'package:Confessi/presentation/feed/widgets/vote_tile.dart';
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
          isActive: false,
          onTap: () => print('like'),
        ),
        const SizedBox(width: 15),
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
