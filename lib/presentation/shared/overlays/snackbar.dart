import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

void showSnackbar(BuildContext context, String message, {VoidCallback? onClosed, bool stayLonger = false}) async {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: stayLonger ? 6000 : 2500),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Row(
            children: [
              Icon(
                CupertinoIcons.info,
                size: 22,
                color: Theme.of(context).colorScheme.background,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  message,
                  style: kBody.copyWith(color: Theme.of(context).colorScheme.background),
                ),
              ),
            ],
          ),
        ),
      )
      .closed
      .then((value) {
    if (onClosed != null) onClosed();
  });
}
