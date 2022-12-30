import 'package:Confessi/presentation/create_post/widgets/slideable_delete_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/styles/typography.dart';
import '../../shared/slideables/slidable_section.dart';

class DraftTile extends StatelessWidget {
  const DraftTile({
    super.key,
    required this.text,
    required this.onDelete,
  });

  final String text;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlideableDeleteSection(
            onPress: () => onDelete(),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 0.8,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          text,
          style: kBody.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
