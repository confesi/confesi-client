import 'package:Confessi/features/feed/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class QuoteTile extends StatelessWidget {
  const QuoteTile({
    required this.postView,
    required this.genre,
    required this.text,
    Key? key,
  }) : super(key: key);

  final PostView postView;
  final String text;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Replying to:',
          style:
              kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 0.35,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                genre,
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 5),
              Text(
                text.length > kPreviewQuotePostTextLength &&
                        postView == PostView.feedView
                    ? "${text.substring(0, kPreviewQuotePostTextLength)}..."
                    : text,
                style: kBody.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
