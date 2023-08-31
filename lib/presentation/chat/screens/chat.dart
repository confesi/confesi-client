import 'package:confesi/models/chat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.initialChats}) : super(key: key);

  final List<Chat> initialChats;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
      ),
      body: ListView.builder(
        reverse: true, // Makes the ListView reversed
        itemCount: widget.initialChats.length,
        itemBuilder: (BuildContext context, int index) {
          // To display chats in reverse order
          Chat chat = widget.initialChats[widget.initialChats.length - index - 1];

          return ListTile(
            leading:
                CircleAvatar(child: Text(chat.userId.substring(0, 1))), // Show the first letter of the userId as avatar
            title: Text(chat.userId),
            subtitle: Text(chat.date.toIso8601String()), // Display the chat date in ISO8601 format
          );
        },
      ),
    );
  }
}
