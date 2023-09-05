import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.roomId, required this.controller});

  final String roomId;
  final TextEditingController controller;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                suffixIcon: AbsorbPointer(
                  absorbing: isLoading,
                  child: TouchableScale(
                    onTap: () async {
                      // strip whitespace
                      widget.controller.text = widget.controller.text.trim();
                      // if empty return
                      if (widget.controller.text.isEmpty) return;
                      setState(() => isLoading = true);
                      String oldValue = widget.controller.text;
                      widget.controller.clear();
                      (await Provider.of<RoomsService>(context, listen: false).addChat(widget.roomId, oldValue)).fold(
                        (_) => null, // on success do nothing
                        (failureMsg) {
                          context.read<NotificationsCubit>().showErr(failureMsg);
                        },
                      );
                      if (mounted) setState(() => isLoading = false);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
