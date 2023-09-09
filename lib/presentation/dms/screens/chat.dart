import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/models/chat.dart';
import 'package:confesi/presentation/dms/widgets/chat_tile.dart';
import 'package:flutter/services.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_highlight.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_shrink.dart';
import 'package:confesi/presentation/shared/buttons/option.dart';
import 'package:confesi/presentation/shared/overlays/button_options_sheet.dart';
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

  Future<void> _promptDeleteMessage(String docId) async {
    bool shouldDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Message'),
              content: Text('Are you sure you want to delete this message?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false; // assuming that the dialog returns null when dismissed

    if (shouldDelete) {
      await FirebaseFirestore.instance.collection('chats').doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatsQuery =
        FirebaseFirestore.instance.collection('chats').orderBy('date', descending: true).withConverter<Chat>(
              fromFirestore: (snapshot, _) =>
                  Chat.fromJson({...snapshot.data() as Map<String, dynamic>, "id": snapshot.id}),
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
                                onEditingComplete: () async {
                                  // unfocus keyboard
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  (await Provider.of<RoomsService>(context, listen: false).updateRoomName(
                                    widget.props.roomId,
                                    chatNameController.text,
                                  ))
                                      .fold(
                                    (_) => null, // do nothing on success
                                    (errMsg) => context
                                        .read<NotificationsCubit>()
                                        .showErr(errMsg), // show notification on error
                                  );
                                },
                                textAlign: TextAlign.center,
                                controller: chatNameController,
                                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  hintText: "Your private chat name",
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(0),
                                  hintStyle: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TouchableOpacity(
                            onTap: () => showButtonOptionsSheet(
                              context,
                              [
                                OptionButton(
                                  onTap: () => print("todo"),
                                  text: "Clear all room messages",
                                  icon: CupertinoIcons.trash,
                                  isRed: true,
                                ),
                                OptionButton(
                                  onTap: () => print("todo"),
                                  text: "Delete room",
                                  icon: CupertinoIcons.trash,
                                  isRed: true,
                                ),
                              ],
                            ),
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
                          Provider.of<RoomsService>(context, listen: false)
                              .rooms[widget.props.roomId]!
                              .chats
                              .insert(0, chat);
                          // only return `ChatTile` if it exists in the room
                          if (!Provider.of<RoomsService>(context, listen: false)
                              .rooms[widget.props.roomId]!
                              .chats
                              .contains(chat)) {
                            return const SizedBox.shrink();
                          }
                          return ChatTile(
                            onLongPress: (isYou) => showButtonOptionsSheet(
                              context,
                              [
                                if (isYou)
                                  OptionButton(
                                    onTap: () async => (await Provider.of<RoomsService>(context, listen: false)
                                            .deleteChat(widget.props.roomId, snapshot.id))
                                        .fold(
                                      (_) => null, // do nothing on success
                                      (errMsg) => context.read<NotificationsCubit>().showErr(errMsg),
                                    ),
                                    text: "Delete chat",
                                    icon: CupertinoIcons.trash,
                                    isRed: true,
                                  ),
                                OptionButton(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: chat.msg));
                                    context.read<NotificationsCubit>().showSuccess("Text copied");
                                  },
                                  text: "Copy text",
                                  icon: CupertinoIcons.rectangle_on_rectangle_angled,
                                ),
                              ],
                            ),
                            key: ValueKey(chat.date),
                            // plus ID
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
