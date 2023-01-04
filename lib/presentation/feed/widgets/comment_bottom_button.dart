import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';

class CommentBottomButton extends StatelessWidget {
  const CommentBottomButton({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        text,
        style: kDetail.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
