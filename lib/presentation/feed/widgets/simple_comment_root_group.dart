import 'package:confesi/presentation/feed/widgets/simple_comment_tile.dart';

import '../../shared/behaviours/animated_cliprrect.dart';
import 'package:flutter/material.dart';

class SimpleCommentRootGroup extends StatefulWidget {
  const SimpleCommentRootGroup({
    super.key,
    required this.root,
    required this.subTree,
  });

  final List<SimpleCommentRootGroup> subTree;
  final SimpleCommentTile root;

  @override
  State<SimpleCommentRootGroup> createState() => _SimpleCommentRootGroupState();
}

class _SimpleCommentRootGroupState extends State<SimpleCommentRootGroup> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPress: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: widget.root,
          ),
        ),
        AnimatedClipRect(
          duration: const Duration(milliseconds: 175),
          reverseDuration: const Duration(milliseconds: 175),
          alignment: Alignment.bottomCenter,
          horizontalAnimation: false,
          open: _isExpanded,
          child: Column(
            children: widget.subTree,
          ),
        )
      ],
    );
  }
}
