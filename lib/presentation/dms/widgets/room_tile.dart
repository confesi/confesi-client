import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/dms/utils/time_ago.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class RoomTile extends StatelessWidget {
  const RoomTile(
      {super.key, required this.lastMsg, required this.name, this.lastChat, required this.onTap, this.read = false});

  final DateTime lastMsg;
  final String name;
  final String? lastChat;
  final VoidCallback onTap;
  final bool read;

  Stream<DateTime> tick() async* {
    while (true) {
      yield DateTime.now();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: borderSize,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.left,
                  ),
                ),
                StreamBuilder<DateTime>(
                  stream: tick(),
                  builder: (context, snapshot) {
                    return Flexible(
                      child: Text(
                        timeAgo(lastMsg),
                        style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.left,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                if (!read)
                  Container(
                    margin: const EdgeInsets.only(right: 5, top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                Flexible(
                  child: Text(
                    lastChat ?? "No messages yet",
                    style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
