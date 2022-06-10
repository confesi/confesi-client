import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class GroupText extends StatelessWidget {
  const GroupText(
      {required this.body,
      required this.header,
      this.widthMultiplier = 100,
      this.leftAlign = false,
      this.small = false,
      Key? key})
      : super(key: key);

  final int widthMultiplier;
  final String header;
  final String body;
  final bool leftAlign;
  final bool small;

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width / 100;
    return SizedBox(
      width: widthFactor * widthMultiplier,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: leftAlign ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            header,
            style: small
                ? kTitle.copyWith(color: Theme.of(context).colorScheme.primary)
                : kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: leftAlign ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: small
                ? kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface)
                : kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: leftAlign ? TextAlign.start : TextAlign.center,
          ),
        ],
      ),
    );
  }
}
