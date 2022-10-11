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
          style: kDisplay.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 34,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        const SizedBox(height: 5),
        LinkText(
          onPress: () => Navigator.of(context).pushNamed("/onboarding"),
          linkText: "Tap here.",
          text: "View tips again? ",
        ),
      ],
    );
  }
}
