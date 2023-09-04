import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/models/chat.dart';
import 'package:confesi/presentation/dms/widgets/chat_tile.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrollable/exports.dart';

import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  final ChatProps props;

  const ChatScreen({Key? key, required this.props}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController chatNameController;
  late TextEditingController chatInputController;

  @override
  void initState() {
    super.initState();
    chatNameController = TextEditingController();
    chatInputController = TextEditingController();
    chatNameController.text = Provider.of<RoomsService>(context, listen: false).rooms[widget.props.roomId]!.name;
  }

  @override
  void dispose() {
    chatNameController.dispose();
    chatInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsQuery =
        FirebaseFirestore.instance.collection('chats').orderBy('date', descending: true).withConverter<Chat>(
              fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
              toFirestore: (chat, _) => chat.toJson(),
            );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: KeyboardDismiss(
        child: Consumer<RoomsService>(
          builder: (context, roomService, _) {
            final roomName = roomService.rooms[widget.props.roomId]!.name;
            if (chatNameController.text != roomName) {
              chatNameController.text = roomName;
            }

            return FooterLayout(
              footer: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.surface,
                      width: 0.8,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: ChatInput(
                    roomId: widget.props.roomId,
                    controller: chatInputController,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3),
                    // bottom border
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: borderSize,
                        ),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          TouchableOpacity(
                            onTap: () => router.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.transparent,
                              child: Icon(CupertinoIcons.arrow_left, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: chatNameController,
                                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  hintText: "Your private chat name",
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(0),
                                  hintStyle: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                  // text: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TouchableOpacity(
                            onTap: () => print("TAP"),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.transparent,
                              child: Icon(CupertinoIcons.ellipsis_circle, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      color: Theme.of(context).colorScheme.shadow,
                      child: FirestoreListView<Chat>(
                        pageSize: 20,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 13, top: 13),
                        reverse: true,
                        query: chatsQuery,
                        itemBuilder: (context, snapshot) {
                          Chat chat = snapshot.data();
                          return ChatTile(
                            key: ValueKey(chat.date),
                            text: chat.msg,
                            isYou: Provider.of<RoomsService>(context, listen: false)
                                    .rooms[widget.props.roomId]!
                                    .userNumber ==
                                chat.userNumber,
                            datetime: chat.date,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
