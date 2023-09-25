import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/services/primary_tab_service/primary_tab_service.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/models/chat.dart';
import 'package:confesi/presentation/dms/widgets/chat_tile.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
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
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
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
  late RoomsService roomsService;

  @override
  void initState() {
    super.initState();
    chatNameController = TextEditingController();
    chatInputController = TextEditingController();

    roomsService = Provider.of<RoomsService>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      chatNameController.text = roomsService.rooms[widget.props.roomId]!.name;
    });
  }

  @override
  void dispose() {
    super.dispose();
    chatNameController.dispose();
    chatInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsQuery =
        FirebaseFirestore.instance.collection('chats').orderBy('date', descending: true).withConverter<Chat>(
              fromFirestore: (snapshot, _) => Chat.fromJson({
                ...snapshot.data() as Map<String, dynamic>,
                "id": snapshot.id,
              }),
              toFirestore: (chat, _) => chat.toJson(),
            );

    return Consumer<RoomsService>(
      builder: (context, roomsService, _) {
        final roomName = roomsService.rooms[widget.props.roomId]?.name ?? '';

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: KeyboardDismiss(
            child: FooterLayout(
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
                            onTap: () {
                              Haptics.f(H.regular);
                              router.pop();
                              Provider.of<RoomsService>(context, listen: false).clearCurrentlyViewingRoomId();
                            },
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
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  (await roomsService.updateRoomName(
                                    widget.props.roomId,
                                    chatNameController.text,
                                  ))
                                      .fold(
                                    (_) => null,
                                    (errMsg) => context.read<NotificationsCubit>().showErr(errMsg),
                                  );
                                },
                                textAlign: TextAlign.center,
                                controller: chatNameController..text = roomName,
                                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  hintText: "Your editable chat name",
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(0),
                                  hintStyle: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TouchableOpacity(
                            onTap: () {
                              Haptics.f(H.regular);
                              showButtonOptionsSheet(
                                context,
                                [
                                  OptionButton(
                                    onTap: () async => (await Provider.of<RoomsService>(context, listen: false)
                                            .clearAllRoomChats(widget.props.roomId))
                                        .fold((_) => null,
                                            (errMsg) => context.read<NotificationsCubit>().showErr(errMsg)),
                                    text: "Clear all room messages",
                                    icon: CupertinoIcons.trash,
                                    isRed: true,
                                  ),
                                  OptionButton(
                                    onTap: () async => (await Provider.of<RoomsService>(context, listen: false)
                                            .deleteRoom(widget.props.roomId))
                                        .fold(
                                      (_) {
                                        // success, so push to home and show success notification
                                        Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(4);
                                        router.go("/home");
                                        context.read<NotificationsCubit>().showSuccess("Room deleted");
                                      },
                                      (errMsg) => context.read<NotificationsCubit>().showErr(errMsg),
                                    ),
                                    text: "Delete room",
                                    icon: CupertinoIcons.trash,
                                    isRed: true,
                                  ),
                                ],
                              );
                            },
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
                      constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      color: Theme.of(context).colorScheme.shadow,
                      child: FirestoreListView<Chat>(
                        pageSize: chatPageSize,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 13, top: 13),
                        reverse: true,
                        query: chatsQuery,
                        itemBuilder: (context, snapshot) {
                          Chat chat = snapshot.data();
                          final userNumber = roomsService.rooms[widget.props.roomId]!.userNumber;
                          return ChatTile(
                            onLongPress: (isYou) => showButtonOptionsSheet(
                              context,
                              [
                                if (isYou)
                                  OptionButton(
                                    onTap: () async => (await Provider.of<RoomsService>(context, listen: false)
                                            .deleteChat(chat.id, widget.props.roomId))
                                        .fold((_) => null,
                                            (errMsg) => context.read<NotificationsCubit>().showErr(errMsg)),
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
                            text: chat.msg,
                            isYou: userNumber == chat.userNumber,
                            datetime: chat.date,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
