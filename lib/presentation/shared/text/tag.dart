import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';

enum TagType { required, optional }

class Tag extends StatelessWidget {
  const Tag({super.key, required this.tagType});

  final TagType tagType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 7, right: 7),
      decoration: BoxDecoration(
        color: tagType == TagType.optional ? const Color(0xffCAFFC6) : const Color.fromARGB(255, 255, 221, 161),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: Text(
        tagType == TagType.optional ? "Optional" : "Required",
        style: kTitle.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
