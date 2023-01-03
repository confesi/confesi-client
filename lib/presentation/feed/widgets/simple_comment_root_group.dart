import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/animated_cliprrect.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_shrink.dart';
import 'package:flutter/material.dart';

import 'simple_comment_tile.dart';

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


// !_isExpanded
//                     ? TouchableOpacity(
//                         onTap: () => setState(() => _isExpanded = !_isExpanded),
//                         child: Container(
//                           color: Theme.of(context).colorScheme.surface,
//                           padding: const EdgeInsets.all(10),
//                           width: double.infinity,
//                           child: Text(
//                             "Expand",
//                             style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
//                           ),
//                         ),
//                       )
//                     : Container(),