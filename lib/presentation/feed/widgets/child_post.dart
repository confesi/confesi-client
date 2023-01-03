import '../../../constants/create_post/general.dart';
import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

class ChildPost extends StatelessWidget {
  const ChildPost({
    super.key,
    required this.body,
    this.onTap,
    required this.title,
  });

  final String title;
  final String body;
  final VoidCallback? onTap;

  Widget buildBody(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Replying to post:",
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 15),
            Text(
              title.length > kChildPostTitlePreviewLength
                  ? '${title.substring(0, kChildPostTitlePreviewLength)}...'
                  : title,
              style: kDisplay1.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 17,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              body.length > kChildPostBodyPreviewLength ? '${body.substring(0, kChildPostBodyPreviewLength)}...' : body,
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return onTap == null
        ? buildBody(context)
        : TouchableScale(
            onTap: () => onTap!(),
            child: buildBody(context),
          );
  }
}