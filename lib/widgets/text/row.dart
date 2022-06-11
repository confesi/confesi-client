import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class RowText extends StatelessWidget {
  const RowText({this.topLine = false, required this.leftText, required this.rightText, Key? key})
      : super(key: key);

  final String leftText;
  final String rightText;
  final bool topLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
            color: topLine ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
            width: topLine ? 1 : 0),
        bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 1),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                leftText,
                style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                rightText,
                style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
