import 'package:confesi/core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../utils/time_ago.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    Key? key,
    required this.text,
    required this.isYou,
    required this.datetime,
  }) : super(key: key);

  final String text;
  final bool isYou;
  final DateTime datetime;

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
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
        double maxWidth = constraints.maxWidth * 0.67;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
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
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: widget.isYou ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  borderRadius: !widget.isYou
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(2),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(2),
                        ),
                ),
                child: Text(
                  widget.text,
                  style: kBody.copyWith(
                    color:
                        widget.isYou ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
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
