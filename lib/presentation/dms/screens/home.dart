import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/room.dart';
import 'package:confesi/presentation/dms/widgets/room_tile.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/layout/appbar.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppbarLayout(
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
                child: FirestoreListView(
                  query: FirebaseFirestore.instance
                      .collection('rooms')
                      .where('user_id', isEqualTo: sl.get<UserAuthService>().uid)
                      .orderBy('last_msg', descending: true),
                  itemBuilder: (context, item) {
                    Room room = Room.fromJson({...item.data(), "id": item.id});
                    final roomsService = Provider.of<RoomsService>(context, listen: false);

                    roomsService.addRoomAndLoadChat(room);

                    return Consumer<RoomsService>(
                      builder: (context, roomsService, _) {
                        final updatedRoom = roomsService.rooms[room.roomId]!;
                        return RoomTile(
                          lastMsg: updatedRoom.lastMsg,
                          name: updatedRoom.name,
                          lastChat: updatedRoom.chats.isNotEmpty ? updatedRoom.chats.last.msg : null,
                          onTap: () => router.push("/home/rooms/chat",
                              extra: ChatProps(
                                updatedRoom.roomId,
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
