import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({required this.count, Key? key}) : super(key: key);

  final int count;

  String getPostfix(commentCount) {
    if (commentCount == 1) {
      return "$commentCount comment";
    } else {
      return "$commentCount comments";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Text(
            getPostfix(count),
            style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
