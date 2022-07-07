import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/typography.dart';

void showErrorSnackbar(BuildContext context, String messageText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2500),
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
              messageText,
              style: kBody.copyWith(color: Theme.of(context).colorScheme.background),
            ),
          ),
        ],
      ),
    ),
  );
}
