import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Theme.of(context).colorScheme.onSurface, width: 0.5),
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "University",
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  "university of victoria",
                  style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            Icon(CupertinoIcons.chevron_forward,
                color: Theme.of(context).colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
