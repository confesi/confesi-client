import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteTileSet extends StatelessWidget {
  const VoteTileSet({
    required this.votes,
    this.isLarge = true,
    Key? key,
  }) : super(key: key);

  final int votes;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoteTile(
          showOutline: isLarge,
          tooltip: 'this is good content',
          icon: CupertinoIcons.hand_thumbsup,
          isActive: true,
          onTap: () => print('like'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            largeNumberFormatter(votes),
            style: isLarge
                ? kBody.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : kDetail.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ),
        ),
        VoteTile(
          showOutline: isLarge,
          tooltip: 'this is bad content',
          icon: CupertinoIcons.hand_thumbsdown,
          isActive: false,
          onTap: () => print('hate'),
        ),
      ],
    );
  }
}
