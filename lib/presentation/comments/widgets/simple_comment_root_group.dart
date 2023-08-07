import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_shrink.dart';
import 'package:flutter/services.dart';
import 'simple_comment_tile.dart';
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
    return Opacity(
      opacity: (!_isExpanded && widget.subTree.isNotEmpty) ? 0.25 : 1.0,
      child: buildCommentColumn(),
    );
  }

  Widget buildCommentColumn() {
    return Column(
      children: [
        widget.subTree.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isExpanded = !_isExpanded);
                },
                child: Container(
                  color: Theme.of(context).colorScheme.shadow,
                  child: widget.root,
                ),
              )
            : widget.root,
        AnimatedClipRect(
          duration: const Duration(milliseconds: 175),
          reverseDuration: const Duration(milliseconds: 175),
          alignment: Alignment.bottomCenter,
          horizontalAnimation: false,
          open: _isExpanded,
          child: Column(
            children: widget.subTree,
          ),
        ),
      ],
    );
  }
}