import 'package:confesi/constants/shared/constants.dart';

import '../../shared/other/widget_or_nothing.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class DraftTile extends StatelessWidget {
  const DraftTile({
    super.key,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: borderSize,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetOrNothing(
              showWidget: title.isNotEmpty && title != " ",
              child: Text(
                title,
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            WidgetOrNothing(
              showWidget: title.isNotEmpty && title != " " && body.isNotEmpty && body != " ",
              child: const SizedBox(height: 5),
            ),
            WidgetOrNothing(
              showWidget: body.isNotEmpty && body != " ",
              child: Text(
                body,
                style: kBody.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
