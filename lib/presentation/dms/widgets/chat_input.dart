import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void sendMsg(String value) async {
    if (value.isEmpty) return;

    setState(() => isLoading = true);

    String oldValue = value.trim();

    final result = await Provider.of<RoomsService>(context, listen: false).addChat(widget.roomId, oldValue);

    result.fold(
      (_) => null, // on success do nothing
      (failureMsg) {
        context.read<NotificationsCubit>().showErr(failureMsg);
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  void _removeNewline() {
    if (widget.controller.text.endsWith('\n')) {
      widget.controller.text = widget.controller.text.substring(0, widget.controller.text.length - 1);
      widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_removeNewline);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_removeNewline);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (key) {
                if (key.isKeyPressed(LogicalKeyboardKey.enter)) {
                  final oldVal = widget.controller.text;
                  setState(() {
                    widget.controller.clear();
                  });
                  sendMsg(oldVal);
                }
              },
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AbsorbPointer(
            absorbing: isLoading,
            child: TouchableScale(
              onTap: () {
                Haptics.f(H.regular);
                final oldVal = widget.controller.text;
                setState(() {
                  widget.controller.clear();
                });
                sendMsg(oldVal);
              },
              child: Container(
                padding: const EdgeInsets.all(13),
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
        ],
      ),
    );
  }
}
