import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/room.dart';
import 'package:confesi/presentation/dms/widgets/room_tile.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/layout/appbar.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../overlays/room_request_sheet.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = sl.get<UserAuthService>().uid;
    final query = FirebaseFirestore.instance
        .collection('rooms')
        .where('user_id', isEqualTo: uid)
        .orderBy('last_msg', descending: true)
        .withConverter<Room>(
          fromFirestore: (snapshot, _) => Room.fromJson({...snapshot.data()!, 'id': snapshot.id}),
          toFirestore: (room, _) => room.toJson(),
        );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                rightIconOnPress: () => showRoomRequestsSheet(context),
                rightIconVisible: true,
                rightIcon: CupertinoIcons.archivebox,
                leftIconVisible: false,
                leftIconDisabled: true,
                bottomBorder: true,
                centerWidget: Text(
                  "Anonymous Messages",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.shadow,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
                      child: StreamBuilder<QuerySnapshot<Room>>(
                        stream: query.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                            return LoadingOrAlert(
                              message: StateMessage("Unknown error", () {}),
                              isLoading: snapshot.connectionState == ConnectionState.waiting,
                            );
                          }

                          if (snapshot.data?.docs.isEmpty ?? true) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.chat_bubble_2_fill,
                                      size: 50,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "No messages available",
                                      style: kBody.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SwipeRefresh(
                              onRefresh: () async =>
                                  await Future.delayed(const Duration(milliseconds: 1000)), // todo: reloader
                              child: FirestoreListView(
                                query: query,
                                itemBuilder: (context, item) {
                                  final room = item.data()!;
                                  return RoomWithChat(room: room);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomWithChat extends StatefulWidget {
  final Room room;

  const RoomWithChat({Key? key, required this.room}) : super(key: key);

  @override
  RoomWithChatState createState() => RoomWithChatState();
}

class RoomWithChatState extends State<RoomWithChat> {
  Future<void>? _loadChatFuture;

  @override
  void initState() {
    super.initState();
    _loadChatFuture = Provider.of<RoomsService>(context, listen: false).addRoomAndLoadChat(widget.room);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadChatFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
          return LoadingOrAlert(
            message: StateMessage("Unknown error", () => setState(() => _loadChatFuture = null)),
            isLoading: snapshot.connectionState == ConnectionState.waiting,
          );
        } else {
          final roomsService = Provider.of<RoomsService>(context); // Get the RoomsService directly here
          final updatedRoom =
              roomsService.rooms[widget.room.roomId]!; // Get the updated room directly using the room ID
          return RoomTile(
            lastMsg: updatedRoom.lastMsg,
            name: updatedRoom.name + updatedRoom.chats.map((e) => e.msg).toString(),
            lastChat: updatedRoom.chats.isNotEmpty ? updatedRoom.chats.first.msg : null,
            onTap: () => router.push("/home/rooms/chat", extra: ChatProps(updatedRoom.roomId)),
          );
        }
      },
    );
  }
}
