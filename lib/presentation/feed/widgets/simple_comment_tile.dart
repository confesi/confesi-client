import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleCommentTile extends StatelessWidget {
  const SimpleCommentTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(color: Theme.of(context).colorScheme.primary, width: 2),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "25m / University of British Columbia",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam porttitor accumsan turpis at ornare. Ut est massa, scelerisque quis felis id, posuere pellentesque ante.",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          CupertinoIcons.arrow_down,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "43.1k",
                          style: kDetail.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          CupertinoIcons.arrow_up,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 18,
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          CupertinoIcons.arrow_turn_up_left,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Reply",
                          style: kDetail.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          CupertinoIcons.ellipsis,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
