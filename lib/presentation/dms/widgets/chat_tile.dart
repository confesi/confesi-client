import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_highlight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../utils/time_ago.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    Key? key,
    required this.text,
    required this.isYou,
    required this.datetime,
    required this.onLongPress,
  }) : super(key: key);

  final String text;
  final bool isYou;
  final DateTime datetime;
  final Function(bool isYou) onLongPress;

  @override
  ChatTileState createState() => ChatTileState();
}

class ChatTileState extends State<ChatTile> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {}); // This will cause the UI to rebuild every minute.
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth * (2 / 3);
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: widget.isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (widget.isYou) ...[
                Expanded(
                  child: Text(timeAgo(widget.datetime),
                      style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right),
                ),
                const SizedBox(width: 8),
              ],
              TouchableHighlight(
                onLongPress: () {
                  HapticFeedback.lightImpact();
                  widget.onLongPress(widget.isYou);
                },
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color:
                        widget.isYou ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
                    borderRadius: !widget.isYou
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(2),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(2),
                          ),
                  ),
                  child: Text(
                    widget.text,
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              if (!widget.isYou) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    timeAgo(widget.datetime),
                    style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
