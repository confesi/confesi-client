// TODO !!!!!!!! => move the constants from here into the shared constants folder

import 'package:Confessi/core/constants/shared/buttons.dart';
import 'package:Confessi/presentation/shared/behaviours/tool_tip.dart';
import 'package:Confessi/core/constants/feed/constants.dart';
import 'package:Confessi/presentation/domain/shared/entities/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/shared/feed.dart';
import '../../../core/styles/typography.dart';

class PreviewQuoteTile extends StatelessWidget {
  const PreviewQuoteTile({
    required this.body,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Replying to:',
            style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          title.isNotEmpty
              ? Text(
                  title.length > kPreviewQuotePostTitleLength
                      ? "${title.substring(0, kPreviewQuotePostTitleLength)}..."
                      : title,
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                )
              : Container(),
          title.isNotEmpty ? const SizedBox(height: 5) : Container(),
          Text(
            body.length > kPreviewQuotePostTextLength
                ? "${body.substring(0, kPreviewQuotePostTextLength)}..."
                : body,
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
