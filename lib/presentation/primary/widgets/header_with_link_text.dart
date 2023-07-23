import 'package:confesi/core/router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/text/link.dart';

class HeaderWithLinkText extends StatelessWidget {
  const HeaderWithLinkText({
    super.key,
    required this.header,
  });

  final String header;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          header,
          style: kDisplay2.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 34,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        LinkText(
          topPadding: 5,
          bottomPadding: 15,
          onPress: () => router.push("/onboarding"),
          linkText: "Tap here.",
          text: "View tips again? ",
        ),
      ],
    );
  }
}
