import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          // Attach button can be added here if needed

          // Text input with the send button inside as a suffix icon
          Expanded(
            child: TextField(
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
                suffixIcon: TouchableScale(
                  onTap: () => print("todo: send"),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
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
        ],
      ),
    );
  }
}
