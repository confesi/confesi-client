import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/utils/strings/truncate_text.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../edited_source_widgets/text.dart';

class HeaderGroupText extends StatelessWidget {
  const HeaderGroupText({
    this.onSecondaryColors = true,
    this.multiLine = false,
    this.left = false,
    this.spaceBetween = 10,
    required this.header,
    required this.body,
    this.expandsTopText = false,
    this.small = false,
    Key? key,
  }) : super(key: key);

  final bool small;
  final bool expandsTopText;
  final String header;
  final String body;
  final bool left;
  final bool multiLine;
  final bool onSecondaryColors;
  final double spaceBetween;

  Widget buildTopText(BuildContext context) => SafeText(
        truncateText(header, dailyHottestPreviewLength),
        style: kFunkyDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
        textAlign: left ? TextAlign.left : TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: multiLine ? 5 : null,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: left ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        expandsTopText ? Expanded(child: buildTopText(context)) : Flexible(child: buildTopText(context)),
        SizedBox(height: spaceBetween),
        SafeText(
          body,
          style: kTitle.copyWith(
            color:
                onSecondaryColors ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.primary,
          ),
          textAlign: left ? TextAlign.left : TextAlign.center,
          overflow: TextOverflow.ellipsis,
          // maxLines: multiLine ? 5 : null,
        ),
      ],
    );
  }
}
