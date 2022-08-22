import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../../core/styles/typography.dart';

class LeaderboardRectangleTile extends StatelessWidget {
  const LeaderboardRectangleTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(
              '4th',
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'University of Waterloo',
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '86 pts',
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
